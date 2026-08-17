//
//  File.swift
//
//
//  Created by Ahmed Tarek on 16/08/2026.
//

import Foundation

public struct OrganizationProfileDTO: Codable {
    public let name: String
    public let photoUrl: String?

    public static func mapToEntity(dto: OrganizationProfileDTO) -> OrganizationProfile {
        OrganizationProfile(name: dto.name, photoUrl: dto.photoUrl)
    }
}

public struct UploadOrganizationPhotoResponseDTO: Codable {
    public let photoUrl: String
}
