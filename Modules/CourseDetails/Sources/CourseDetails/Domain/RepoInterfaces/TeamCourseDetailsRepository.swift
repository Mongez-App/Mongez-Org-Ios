//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation

public protocol TeamCourseDetailsRepository {
    func getMaterials(courseId: String, organizationId: String) async throws -> [TeamCourseMaterial]
    func uploadMaterial(courseId: String, fileData: Data, fileName: String, mimeType: String) async throws -> TeamCourseMaterial
}
