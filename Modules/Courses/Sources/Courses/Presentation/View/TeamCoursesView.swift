//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common

public struct TeamCoursesView: View {
    @ObservedObject var viewModel: TeamCoursesViewModel
    @ObservedObject var eventsViewModel: EventsViewModel
    @ObservedObject var coordinator: TeamCoursesCoordinator

    @State private var selectedTab: String = "Courses"
    @State private var searchText: String = ""

    public init(viewModel: TeamCoursesViewModel, eventsViewModel: EventsViewModel, coordinator: TeamCoursesCoordinator) {
        self.viewModel = viewModel
        self.eventsViewModel = eventsViewModel
        self.coordinator = coordinator
    }
    
    private var filteredCourses: [TeamCourse] {
        if searchText.isEmpty {
            return viewModel.courses
        } else {
            return viewModel.courses.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: AppTheme.Spacing.small) {
                Button(action: { coordinator.onFinish?() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple200)
                }
                
                Text(coordinator.teamName)
                    .font(AppTheme.textStyle(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                Spacer()
                
                Button(action: {
                    switch selectedTab {
                    case "Events": coordinator.presentSheet(.addEvent)
                    default: coordinator.presentSheet(.addCourse)
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple200)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(AppTheme.Colors.white100)
                                .appShadow(opacity: 0.7, radius: 2.5)
                        )
                }
            }
            .padding(.horizontal, AppTheme.Spacing.medium)
            .padding(.top, AppTheme.Spacing.small)
            .padding(.bottom, AppTheme.Spacing.medium)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(["Courses", "Events", "Members"], id: \.self) { tab in
                        VStack(spacing: AppTheme.Spacing.xSmall) {
                            Text(tab)
                                .font(AppTheme.textStyle(size: 18, weight: selectedTab == tab ? .bold : .medium))
                                .foregroundColor(selectedTab == tab ? AppTheme.Colors.purple200 : AppTheme.Colors.gray300)
                            
                            Capsule()
                                .fill(selectedTab == tab ? AppTheme.Colors.purple200 : Color.clear)
                                .frame(height: 3)
                                .padding(.horizontal, AppTheme.Spacing.small)
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
                        }
                    }
                }
                Rectangle()
                    .fill(AppTheme.Colors.gray200)
                    .frame(height: 1)
                    .padding(.horizontal, AppTheme.Spacing.medium)
                    .offset(y: -1)
            }
            .padding(.bottom, AppTheme.Spacing.large)
            
            switch selectedTab {
            case "Courses":
                CoursesTabView(
                    searchText: $searchText,
                    courses: filteredCourses,
                    isLoading: viewModel.isLoading,
                    onAddCourse: { coordinator.presentSheet(.addCourse) },
                    onCourseTapped: { course in
                        coordinator.push(.courseDetails(courseId: course.id, courseName: course.title))
                    }
                )
            case "Events":
                EventsTabView(
                    viewModel: eventsViewModel,
                    courses: viewModel.courses,
                    onAddEvent: { coordinator.presentSheet(.addEvent) }
                )
            case "Members":
                MembersTabView(viewModel: viewModel)
            default:
                EmptyView()
            }
        }
        .task {
            await viewModel.fetchCourses()
        }
    }
}
