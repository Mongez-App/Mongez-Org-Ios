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
        
        return container
    }()

    @Published public var state: AppState = .splash
    // @Published public var authCoordinator: AuthCoordinator?
    // @Published public var dashboardCoordinator: DashboardCoordinator?
    @Published public var teamCoursesCoordinator: TeamCoursesCoordinator?
    
    public init() {
        setupLogoutListener()
    }
    
    public func finishSplash() {
        startTeamCourses(teamId: "3448cf6e-3811-4eee-8548-bd9d43748589", organizationId: "org22")
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
        self.state = .auth
    }
    
    public func startTeamCourses(teamId: String, organizationId: String) {
        let coordinator = TeamCoursesCoordinator(teamId: teamId, organizationId: organizationId)
        addChild(coordinator)
        self.teamCoursesCoordinator = coordinator
        self.state = .teamCourses
    }
}
