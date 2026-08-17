//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
import Common

public class UploadTeamCourseMaterialUseCase {
    private let repository: TeamCourseDetailsRepository
    private let cloudinaryService: CloudinaryServiceProtocol
    
    public init(repository: TeamCourseDetailsRepository, cloudinaryService: CloudinaryServiceProtocol) {
        self.repository = repository
        self.cloudinaryService = cloudinaryService
    }
    
    public func execute(courseId: String, fileData: Data, fileName: String) async throws -> TeamCourseMaterial {
        do {
            let _ = try await cloudinaryService.uploadPDF(fileData: fileData, fileName: fileName)
        } catch {
            print("Warning: Cloudinary upload failed (\(error)), but proceeding with backend upload.")
        }
    
        return try await repository.uploadMaterial(
            courseId: courseId,
            fileData: fileData,
            fileName: fileName,
            mimeType: "application/pdf"
        )
    }
}
