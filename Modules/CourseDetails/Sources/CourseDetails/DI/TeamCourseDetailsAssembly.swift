//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
import Swinject
import Common

public class TeamCourseDetailsAssembly: DIAssembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(CloudinaryServiceProtocol.self) { _ in
            CloudinaryService()
        }.inObjectScope(.container)
        
        container.register(TeamCourseDetailsRepository.self) { _ in
            TeamCourseDetailsRepositoryImpl()
        }
        
        container.register(GetTeamCourseMaterialsUseCase.self) { resolver in
            GetTeamCourseMaterialsUseCase(repository: resolver.resolve(TeamCourseDetailsRepository.self)!)
        }
        
        container.register(UploadTeamCourseMaterialUseCase.self) { resolver in
            UploadTeamCourseMaterialUseCase(
                repository: resolver.resolve(TeamCourseDetailsRepository.self)!,
                cloudinaryService: resolver.resolve(CloudinaryServiceProtocol.self)!
            )
        }
        
        container.register(TeamCourseDetailsViewModel.self) { (resolver, courseId: String, courseName: String, organizationId: String) in
            TeamCourseDetailsViewModel(
                courseId: courseId,
                courseName: courseName,
                organizationId: organizationId,
                getMaterialsUseCase: resolver.resolve(GetTeamCourseMaterialsUseCase.self)!,
                uploadMaterialUseCase: resolver.resolve(UploadTeamCourseMaterialUseCase.self)!
            )
        }
    }
}
