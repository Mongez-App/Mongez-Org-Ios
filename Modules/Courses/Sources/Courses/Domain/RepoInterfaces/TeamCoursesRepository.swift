//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation

public protocol TeamCoursesRepository {
    func getTeamCourses(teamId: String, organizationId: String) async throws -> [TeamCourse]
    func createTeamCourse(teamId: String, organizationId: String, name: String, startDate: String, endDate: String, thumbnailUrl: String, materialIds: [String]) async throws -> String
    func uploadTeamCourseMaterial(courseId: String, fileData: Data, fileName: String, mimeType: String) async throws -> String
}
