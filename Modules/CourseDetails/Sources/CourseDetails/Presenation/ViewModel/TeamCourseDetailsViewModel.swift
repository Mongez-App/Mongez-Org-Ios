//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
public class TeamCourseDetailsViewModel: ObservableObject {
    @Published public var materials: [TeamCourseMaterial] = []
    @Published public var courseName: String
    @Published public var isLoading: Bool = false
    @Published public var isUploading: Bool = false
    @Published public var showFileImporter: Bool = false
    
    private let courseId: String
    private let organizationId: String
    
    private let getMaterialsUseCase: GetTeamCourseMaterialsUseCase
    private let uploadMaterialUseCase: UploadTeamCourseMaterialUseCase
    
    nonisolated public init(
        courseId: String,
        courseName: String,
        organizationId: String,
        getMaterialsUseCase: GetTeamCourseMaterialsUseCase,
        uploadMaterialUseCase: UploadTeamCourseMaterialUseCase
    ) {
        self.courseId = courseId
        self._courseName = Published(wrappedValue: courseName)
        self.organizationId = organizationId
        self.getMaterialsUseCase = getMaterialsUseCase
        self.uploadMaterialUseCase = uploadMaterialUseCase
    }
    
    public func loadData() async {
        isLoading = true
        do {
            materials = try await getMaterialsUseCase.execute(courseId: courseId, organizationId: organizationId)
        } catch {
            print("Failed to load materials: \(error)")
        }
        isLoading = false
    }
    
    public func uploadMaterial(fileURL: URL) async {
        guard fileURL.startAccessingSecurityScopedResource() else { return }
        defer { fileURL.stopAccessingSecurityScopedResource() }
        
        do {
            isUploading = true
            let fileData = try Data(contentsOf: fileURL)
            let fileName = fileURL.lastPathComponent
            
            _ = try await uploadMaterialUseCase.execute(
                courseId: courseId,
                fileData: fileData,
                fileName: fileName
            )
            
            await loadData() // Refresh list after successful upload
            isUploading = false
        } catch {
            print("Error uploading material: \(error)")
            isUploading = false
        }
    }
    
    // MARK: - Stubs for CourseDetailsView
    @Published public var courseType: String = "PDF_COURSE"
    
    public func updateCourse(name: String, imageData: Data?) async {
        self.courseName = name
        // TODO: Implement update course API
    }
    
    public func deleteCourse() async {
        // TODO: Implement delete course API
    }
    
    public func deleteMaterial(materialId: String) async {
        // TODO: Implement delete material API
        self.materials.removeAll { $0.id == materialId }
    }
}
