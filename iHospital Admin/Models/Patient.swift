import Foundation

struct Patient: Identifiable {
    let id = UUID()
    let patientID: String
    let name: String
    let age: Int
    let gender: String
    let startTime: Date
    let endTime: Date
    let appointmentDate: Date
}

