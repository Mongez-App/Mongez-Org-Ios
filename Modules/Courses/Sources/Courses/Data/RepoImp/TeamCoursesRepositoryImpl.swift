//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import Common

public class TeamCoursesRepositoryImpl: TeamCoursesRepository {
    public init() {}
    
    public func getTeamCourses(teamId: String, organizationId: String) async throws -> [TeamCourse] {
        let endpoint = TeamCoursesEndPoint.getCourses(teamId: teamId, organizationId: organizationId)
        let response = try await NetworkManger.shared.request(endpoint: endpoint, responseType: GetTeamCoursesResponseDTO.self)
        return response.courses.map { $0.toDomain() }
    }
    
    public func createTeamCourse(teamId: String, organizationId: String, name: String, startDate: String, endDate: String, thumbnailUrl: String, materialIds: [String]) async throws -> String {
        let requestDTO = CreateTeamCourseRequestDTO(teamId: teamId, name: name, startDate: startDate, endDate: endDate, thumbnailUrl: thumbnailUrl, materialIds: materialIds)
        let endpoint = TeamCoursesEndPoint.createCourse(request: requestDTO, organizationId: organizationId)
        let response = try await NetworkManger.shared.request(endpoint: endpoint, responseType: CreateTeamCourseResponseDTO.self)
        return response.id
    }
    
    public func uploadTeamCourseMaterial(courseId: String, fileData: Data, fileName: String, mimeType: String) async throws -> String {
        let boundary = "Boundary-\(UUID().uuidString)"
        let endpoint = TeamCoursesEndPoint.uploadMaterial(courseId: courseId, fileData: fileData, fileName: fileName, mimeType: mimeType, boundary: boundary)
        let response = try await NetworkManger.shared.request(endpoint: endpoint, responseType: UploadTeamCourseMaterialResponseDTO.self)
        return response.fileUrl
    }
}
