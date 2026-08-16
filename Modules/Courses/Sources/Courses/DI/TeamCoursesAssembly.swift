//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import Swinject
import Common

public class TeamCoursesAssembly: DIAssembly {
    public init() {}
    
    public func assemble(container: Container) {
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
        container.register(GetTeamMembersUseCase.self) { resolver in
            GetTeamMembersUseCase(repository: resolver.resolve(TeamCoursesRepository.self)!)
        }
        container.register(AcceptMemberUseCase.self) { resolver in
            AcceptMemberUseCase(repository: resolver.resolve(TeamCoursesRepository.self)!)
        }
        container.register(DeclineMemberUseCase.self) { resolver in
            DeclineMemberUseCase(repository: resolver.resolve(TeamCoursesRepository.self)!)
        }
        
        container.register(TeamCoursesViewModel.self) { (resolver, teamId: String, organizationId: String) in
            TeamCoursesViewModel(
                teamId: teamId,
                organizationId: organizationId,
                getCoursesUseCase: resolver.resolve(GetTeamCoursesUseCase.self)!,
                createTeamCourseUseCase: resolver.resolve(CreateTeamCourseUseCase.self)!,
                getTeamMembersUseCase: resolver.resolve(GetTeamMembersUseCase.self)!,
                acceptMemberUseCase: resolver.resolve(AcceptMemberUseCase.self)!,
                declineMemberUseCase: resolver.resolve(DeclineMemberUseCase.self)!
            )
        }
    }
}
