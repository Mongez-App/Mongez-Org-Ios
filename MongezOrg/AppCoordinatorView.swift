import Foundation
import SwiftUI
import Courses
import OrganizationAuth
import Common

public struct AppCoordinatorView: View {
    @StateObject public var coordinator: AppCoordinator
    
    public init(coordinator: AppCoordinator) {
        self._coordinator = StateObject(wrappedValue: coordinator)
    }
    
    public var body: some View {
        Group {
            switch coordinator.state {
            case .splash:
                Color.clear
                    .onAppear {
                        coordinator.finishSplash()
                    }
            case .auth:
                if let authCoordinator = coordinator.authCoordinator {
                    OrganizationAuthCoordinatorView(coordinator: authCoordinator) {
                        AnyView(
                            Color.clear
                                .onAppear {
                                    coordinator.state = .dashboard
                                }
                        )
                    }
                } else {
                    Text("Loading Auth...")
                }
            case .dashboard:
                MainTabContainer(selectedTab: $coordinator.selectedTab) { tab in
                    switch tab {
                    case .dashboard:
                        VStack {
                            Text("Dashboard Placeholder")
                                .font(.largeTitle)
                        }
                    case .teams:
                        VStack {
                            Text("Teams Placeholder")
                                .font(.largeTitle)
                            Button("Go to Courses") {
                                coordinator.startTeamCourses(teamId: "3448cf6e-3811-4eee-8548-bd9d43748589", organizationId: "org22")
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    case .profile:
                        VStack {
                            Text("Profile Placeholder")
                                .font(.largeTitle)
                        }
                    }
                }
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
