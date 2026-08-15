//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common

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
                    case .courseDetails(let courseId):
                        Text("Course Details for \(courseId)") // Replace with CourseDetailsCoordinatorView later
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
