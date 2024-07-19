//
//  FileManager.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 15/07/24.
//

import Foundation

extension FileManager {
    // Saves data to a temporary directory and returns the file URL
    static func saveToTempDirectory(fileName: String, data: Data) throws -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        // Write data to the file URL
        try data.write(to: fileURL)
        
        return fileURL
    }
    
    // Checks if a temporary file exists and returns its URL if it does
    static func tempFileExists(fileName: String) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        // Check if the file exists at the specified path
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        }
        
        return nil
    }
}
