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
    @StateObject public var eventsViewModel: EventsViewModel

    public init(coordinator: TeamCoursesCoordinator, viewModel: TeamCoursesViewModel, eventsViewModel: EventsViewModel) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._eventsViewModel = StateObject(wrappedValue: eventsViewModel)
    }

    public var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            TeamCoursesView(viewModel: viewModel, eventsViewModel: eventsViewModel, coordinator: coordinator)
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
                    case .addEvent:
                        AddEventSheetView(viewModel: eventsViewModel, courses: viewModel.courses)
                    default:
                        EmptyView()
                    }
                }
        }
    }
}
