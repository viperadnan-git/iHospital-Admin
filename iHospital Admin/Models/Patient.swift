import Foundation

struct Patient: Codable {
    let id: UUID
    let name: String
    let age: Int
    let gender: Gender
    
//    static var patientdetails : [Patient]{
//        [Patient(patientID: "001", name: "Alex Carry", age: 23, gender: "Male"),
//         Patient(patientID: "002", name: "Latin Cromnnis", age: 21, gender: "Male")
//        ]
//    }
}

