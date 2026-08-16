//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
import Common

public struct GetTeamCourseMaterialsUseCase {
    private let repository: TeamCourseDetailsRepository
    
    public init(repository: TeamCourseDetailsRepository) {
        self.repository = repository
    }
    
    public func execute(courseId: String, organizationId: String) async throws -> [TeamCourseMaterial] {
        return try await repository.getMaterials(courseId: courseId, organizationId: organizationId)
    }
}
