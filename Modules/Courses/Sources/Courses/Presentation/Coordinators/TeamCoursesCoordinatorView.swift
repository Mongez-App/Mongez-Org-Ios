//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common
import CourseDetails

public struct TeamCoursesCoordinatorView: View {
    @StateObject public var coordinator: TeamCoursesCoordinator
    @StateObject public var viewModel: TeamCoursesViewModel
    public init(coordinator: TeamCoursesCoordinator, viewModel: TeamCoursesViewModel) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            TeamCoursesView(viewModel: viewModel, coordinator: coordinator)
                .navigationDestination(for: TeamCoursesRoute.self) { route in
                    switch route {
                    case .courseDetails(let courseId, let courseName):
                        if let detailsViewModel = coordinator.container.resolve(TeamCourseDetailsViewModel.self, arguments: courseId, courseName, coordinator.organizationId) {
                            let detailsCoordinator = TeamCourseDetailsCoordinator()
                            TeamCourseDetailsCoordinatorView(coordinator: detailsCoordinator, viewModel: detailsViewModel)
                        } else {
                            Text("Error loading details")
                        }
                    default:
                        EmptyView()
                    }
                }
                .sheet(item: $coordinator.sheetRoute) { route in
                    switch route {
                    case .addCourse:
                        AddCourseSheetView(viewModel: viewModel)
                    default:
                        EmptyView()
                    }
                }
        }
    }
}
