//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
import Common

public class TeamCourseDetailsRepositoryImpl: TeamCourseDetailsRepository {
    public init() {}
    
    public func getMaterials(courseId: String, organizationId: String) async throws -> [TeamCourseMaterial] {
        let endpoint = TeamCourseDetailsEndPoint.getMaterials(courseId: courseId, organizationId: organizationId)
        let response = try await NetworkManger.shared.request(endpoint: endpoint, responseType: GetTeamCourseMaterialsResponseDTO.self)
        return response.materials.map { $0.toDomain() }
    }
    
    public func uploadMaterial(courseId: String, fileData: Data, fileName: String, mimeType: String) async throws -> TeamCourseMaterial {
        let boundary = "Boundary-\(UUID().uuidString)"
        let endpoint = TeamCourseDetailsEndPoint.uploadMaterial(courseId: courseId, fileData: fileData, fileName: fileName, mimeType: mimeType, boundary: boundary)
        let dto = try await NetworkManger.shared.request(endpoint: endpoint, responseType: TeamCourseMaterialDTO.self)
        return dto.toDomain()
    }
}
