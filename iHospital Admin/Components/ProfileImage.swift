//
//  ProfileImage.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 18/07/24.
//

import SwiftUI

struct ProfileImage: View {
    let userId: UUID
    var placeholder: Image = Image(systemName: "person.crop.circle.fill")
    
    var body: some View {
        Image.asyncImage(
            loadData: {
                try await fetchImageData(for: userId)
            },
            placeholder: placeholder,
            cacheKey: "AV#\(userId.uuidString)",
            showProgress: false
        ).clipShape(Circle())
    }
    
    private func fetchImageData(for userId: UUID) async throws -> Data {
        let path = "\(userId.uuidString.lowercased())/avatar.jpeg"
        return try await supabase.storage.from(SupabaseBucket.avatars.id)
            .download(path: path)
    }
}
