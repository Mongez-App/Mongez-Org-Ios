//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common

import Foundation
import SwiftUI
import Common

public struct CoursesTabView: View {
    @Binding var searchText: String
    let courses: [TeamCourse]
    let onAddCourse: () -> Void
    
    public init(searchText: Binding<String>, courses: [TeamCourse], onAddCourse: @escaping () -> Void) {
        self._searchText = searchText
        self.courses = courses
        self.onAddCourse = onAddCourse
    }
    
    public var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            HStack(spacing: AppTheme.Spacing.xSmall) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(AppTheme.Colors.gray300)
                TextField("Search courses...", text: $searchText)
                    .font(AppTheme.textStyle(size: 16))
            }
            .padding(.vertical, 16)
            .padding(.horizontal, AppTheme.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppTheme.Colors.gray100, lineWidth: 1.2)
            )
            .padding(.horizontal, AppTheme.Spacing.medium)
            
            if courses.isEmpty {
                TeamCoursesEmptyStateView(onAddCourse: onAddCourse)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: AppTheme.Spacing.large) {
                        ForEach(courses) { course in
                            TeamCourseCardView(course: course)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.medium)
                    .padding(.top, AppTheme.Spacing.small)
                    .padding(.bottom, AppTheme.Spacing.xxLarge)
                }
            }
        }
    }
}
