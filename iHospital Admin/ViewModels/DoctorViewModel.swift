import SwiftUI
import Supabase

class DoctorViewModel: ObservableObject {
    @Published var doctor: Doctor?
    @Published var appointments: [Appointment] = []
    @Published var revenue = 0
    @Published var isLoading = true
    @Published var currentAppointment: Appointment?
    @Published var nextAppointment: Appointment?
    
    private var appointmentTimer: Timer?
    
    @MainActor
    init() {
        fetchDoctor()
        startAppointmentTimer()
    }
    
    @MainActor
    func fetchDoctor() {
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            
            do {
                let doctor = try await Doctor.getMe()
                self.doctor = doctor
                self.fetchAppointments(for: Date())
            } catch {
                print("Error fetching current doctor: \(error)")
                if let error = error as? PostgrestError {
                    if let errorCode = error.code {
                        // doctor not found in doctors table
                        if errorCode == "PGRST116"  {
                            print("Doctor not found in doctors table, logging out...")
                            try await SupaUser.logout()
                        }
                    }
                }
            }
        }
    }
    
    func fetchAppointments(for date: Date) {
        guard let doctor = doctor else {
            return
        }
        
        Task {
            do {
                let appointments = try await doctor.fetchAppointments(for: date)
                DispatchQueue.main.async {
                    self.appointments = appointments.sorted { $0.date < $1.date }
                    self.updateCurrentAndNextAppointment()
                    self.updateRevenue()
                }
            } catch {
                print("Error fetching appointments: \(error)")
            }
        }
    }
    
    func markStatusCompleted(for appointment: Appointment) async throws {
        try await appointment.updateStatus(.completed)
        fetchAppointments(for: Date())
    }
    
    var remainingAppointments: [Appointment] {
        let now = Date()
        return appointments.filter { ($0.status == .pending || $0.status == .confirmed) && $0.date > now }
    }
    
    private func startAppointmentTimer() {
        let now = Date()
        let calendar = Calendar.current
        
        if let nextQuarterHour = calendar.nextDate(after: now, matching: DateComponents(minute: 0), matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward) {
            let delay = nextQuarterHour.timeIntervalSince(now)
            appointmentTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
                self?.fetchAppointments(for: Date())
                self?.scheduleRepeatingTimer()
            }
        }
    }
    
    private func scheduleRepeatingTimer() {
        appointmentTimer = Timer.scheduledTimer(withTimeInterval: 900, repeats: true) { [weak self] _ in
            self?.fetchAppointments(for: Date())
        }
    }
    
    private func updateCurrentAndNextAppointment() {
        let now = Date()
        currentAppointment = nil
        nextAppointment = nil
        
        for appointment in appointments {
            if appointment.date <= now && appointment.date.nextQuarter >= now && (appointment.status == .pending || appointment.status == .confirmed) {
                currentAppointment = appointment
                break
            }
        }
        
        if currentAppointment == nil {
            for appointment in appointments where appointment.date > now && (appointment.status == .pending || appointment.status == .confirmed) {
                nextAppointment = appointment
                break
            }
        }
    }
    
    private func updateRevenue() {
        guard let fee = doctor?.fee else {
            return
        }
        
        self.revenue = fee * appointments.count
    }
    
    deinit {
        appointmentTimer?.invalidate()
    }
}
