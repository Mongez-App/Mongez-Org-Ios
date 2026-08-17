//
//  AppCoordinator.swift
//  MongezOrg
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import Combine
import SwiftUI
import Common
import Swinject
import Courses
import OrganizationAuth
import Teams
import Profile

public enum AppState {
    case splash
    case auth
    case dashboard
    case teamCourses
}

@MainActor
public final class AppCoordinator: ObservableObject, Coordinator {
    public let id = UUID()
    public var childCoordinators: [any Coordinator] = []
    private var cancellables = Set<AnyCancellable>()
    
    public let container: Container = {
        let container = Container()
        TeamCoursesAssembly().assemble(container: container)
        TeamsAssembly().assemble(container: container)
        ProfileAssembly().assemble(container: container)
        
        container.register(OrganizationAuthRepository.self) { _ in
            let networkService = OrganizationAuthNetworkServiceImpl()
            return OrganizationAuthRepositoryImpl(networkService: networkService)
        }
        
        container.register(AuthUseCase.self) { resolver in
            AuthUseCaseImpl(repository: resolver.resolve(OrganizationAuthRepository.self)!)
        }
        
        return container
    }()

    @Published public var state: AppState = .splash
    @Published public var authCoordinator: OrganizationAuthCoordinator?
    // @Published public var dashboardCoordinator: DashboardCoordinator?
    @Published public var teamCoursesCoordinator: TeamCoursesCoordinator?
    @Published public var selectedTab: AppTab = .dashboard
    
    public init() {
        setupLogoutListener()
    }
    
    public func finishSplash() {
        if UserDefaults.standard.string(forKey: "current_user_id") != nil {
            self.state = .dashboard
        } else {
            startAuth()
        }
    }
    
    private func setupLogoutListener() {
        NotificationCenter.default.publisher(for: NSNotification.Name("UserDidLogoutNotification"))
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.handleLogout()
            }
            .store(in: &cancellables)
    }
    
    private func handleLogout() {
        childCoordinators.removeAll()
        teamCoursesCoordinator = nil
        
        startAuth()
    }
    
    public func startAuth() {
        let useCase = container.resolve(AuthUseCase.self)!
        let coordinator = OrganizationAuthCoordinator(useCase: useCase)
        self.authCoordinator = coordinator
        self.state = .auth
    }
    
    public func startTeamCourses(teamId: String, teamName: String, organizationId: String) {
        let coordinator = TeamCoursesCoordinator(teamId: teamId, organizationId: organizationId, teamName: teamName, container: container)
        coordinator.onFinish = { [weak self] in
            self?.state = .dashboard
            self?.teamCoursesCoordinator = nil
        }
        addChild(coordinator)
        self.teamCoursesCoordinator = coordinator
        self.state = .teamCourses
    }
}
