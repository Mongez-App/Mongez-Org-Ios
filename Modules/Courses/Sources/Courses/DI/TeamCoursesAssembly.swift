//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import Swinject
import Common
import CourseDetails

public class TeamCoursesAssembly: DIAssembly {
    public init() {}
    
    public func assemble(container: Container) {
        TeamCourseDetailsAssembly().assemble(container: container)
        
        container.register(TeamCoursesRepository.self) { _ in
            TeamCoursesRepositoryImpl()
        }
        
        container.register(GetTeamCoursesUseCase.self) { resolver in
            GetTeamCoursesUseCase(repository: resolver.resolve(TeamCoursesRepository.self)!)
        }
        container.register(CreateTeamCourseUseCase.self) { resolver in
            CreateTeamCourseUseCase(repository: resolver.resolve(TeamCoursesRepository.self)!)
        }
        container.register(UploadTeamCourseMaterialUseCase.self) { resolver in
            UploadTeamCourseMaterialUseCase(repository: resolver.resolve(TeamCoursesRepository.self)!)
        }
        
        container.register(TeamCoursesViewModel.self) { (resolver, teamId: String, organizationId: String) in
            TeamCoursesViewModel(
                teamId: teamId,
                organizationId: organizationId,
                getCoursesUseCase: resolver.resolve(GetTeamCoursesUseCase.self)!,
                createTeamCourseUseCase: resolver.resolve(CreateTeamCourseUseCase.self)!,
                uploadTeamCourseMaterialUseCase: resolver.resolve(UploadTeamCourseMaterialUseCase.self)!,
                cloudinaryService: resolver.resolve(CloudinaryServiceProtocol.self)!
            )
        }
    }
}
