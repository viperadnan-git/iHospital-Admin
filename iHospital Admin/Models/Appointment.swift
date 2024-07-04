//
//  Appointments.swift
//  iHospital Admin
//
//  Created by Aditya on 04/07/24.
//

import Foundation

struct Appointment: Codable,Identifiable,Equatable {
    static func == (lhs: Appointment, rhs: Appointment) -> Bool {
        lhs.appointmentTime > rhs.appointmentTime
    }
    
    let id: UUID
    let patient: Patient
    let phoneNumber: String
    let doctor: Doctor
    let appointmentTime: Date
    
}
