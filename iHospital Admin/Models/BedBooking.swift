//
//  BedBooking.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 16/07/24.
//

import Foundation

struct BedBooking: Codable {
    let id: Int
    let price: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case price
    }
    
    // Sample instance for testing or previews
    static let sample = BedBooking(id: 1, price: 200)
}

