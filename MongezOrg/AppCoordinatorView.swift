//
//  AppCoordinatorView.swift
//  MongezOrg
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Courses

public struct AppCoordinatorView: View {
    @StateObject public var coordinator: AppCoordinator
    
    public init(coordinator: AppCoordinator) {
        self._coordinator = StateObject(wrappedValue: coordinator)
    }
    
    public var body: some View {
        Group {
            switch coordinator.state {
            case .splash:
                Text("Loading...")
                    .onAppear {
                        coordinator.finishSplash()
                    }
            case .auth:
                Text("Auth")
            case .dashboard:
                Text("Dashboard")
            case .teamCourses:
                if let teamCoursesCoordinator = coordinator.teamCoursesCoordinator,
                   let viewModel = coordinator.container.resolve(TeamCoursesViewModel.self, arguments: teamCoursesCoordinator.teamId, teamCoursesCoordinator.organizationId) {
                    TeamCoursesCoordinatorView(coordinator: teamCoursesCoordinator, viewModel: viewModel)
                } else {
                    Text("Error Loading Team Courses")
                }
            }
        }
    }
}
