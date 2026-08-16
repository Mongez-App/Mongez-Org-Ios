import Foundation
import SwiftUI
import Courses
import OrganizationAuth
import Profile
import Common
import Teams
import Dashboard

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
                        DashboardView()
                    case .teams:
                        if let viewModel = coordinator.container.resolve(TeamsViewModel.self) {
                            TeamsView(viewModel: viewModel) { teamId, teamName in
                                coordinator.startTeamCourses(
                                    teamId: teamId,
                                    teamName: teamName,
                                    organizationId: UserDefaults.standard.string(forKey: "current_user_id") ?? ""
                                )
                            }
                        } else {
                            Text("Error Loading Teams")
                        }
                    case .profile:
                        ProfileView()
                    }
                }
            case .teamCourses:
                if let teamCoursesCoordinator = coordinator.teamCoursesCoordinator,
                   let viewModel = coordinator.container.resolve(TeamCoursesViewModel.self, arguments: teamCoursesCoordinator.teamId, teamCoursesCoordinator.organizationId),
                   let eventsViewModel = coordinator.container.resolve(EventsViewModel.self, arguments: teamCoursesCoordinator.teamId, teamCoursesCoordinator.organizationId) {
                    TeamCoursesCoordinatorView(coordinator: teamCoursesCoordinator, viewModel: viewModel, eventsViewModel: eventsViewModel)
                } else {
                    Text("Error Loading Team Courses")
                }
            }
        }
    }
}
