//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
public struct UploadTeamCourseMaterialUseCase {
    private let repository: TeamCoursesRepository
    public init(repository: TeamCoursesRepository) { self.repository = repository }
    
    public func execute(courseId: String, fileData: Data, fileName: String, mimeType: String = "application/pdf") async throws -> String {
        return try await repository.uploadTeamCourseMaterial(courseId: courseId, fileData: fileData, fileName: fileName, mimeType: mimeType)
    }
}
