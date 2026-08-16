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
        return response.courses?.map { $0.toDomain() } ?? []
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
    
    public func getTeamMembers(teamId: String) async throws -> (pending: [TeamMember], active: [TeamMember]) {
        let endpoint = TeamCoursesEndPoint.getMembers(teamId: teamId)
        let response = try await NetworkManger.shared.request(endpoint: endpoint, responseType: GetTeamMembersResponseDTO.self)
        
        let pending = response.pendingMembers.map { $0.toDomain() }
        let active = response.teamMembers.map { $0.toDomain() }
        
        return (pending: pending, active: active)
    }
    
    public func acceptMember(memberId: String) async throws {
        let requestDTO = MemberActionRequestDTO(memberId: memberId)
        let endpoint = TeamCoursesEndPoint.acceptMember(request: requestDTO)
        // Since we don't necessarily need the response data, we can just use requestRaw or map to a dummy response
        // Using TeamMemberDTO as response since accept returns the updated member
        _ = try await NetworkManger.shared.request(endpoint: endpoint, responseType: TeamMemberDTO.self)
    }
    
    public func declineMember(memberId: String) async throws {
        let requestDTO = MemberActionRequestDTO(memberId: memberId)
        let endpoint = TeamCoursesEndPoint.declineMember(request: requestDTO)
        // Using TeamMemberDTO as response since decline returns the updated member
        _ = try await NetworkManger.shared.request(endpoint: endpoint, responseType: TeamMemberDTO.self)
    }
}
