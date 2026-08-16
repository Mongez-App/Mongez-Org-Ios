//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common

public struct EventsTabView: View {
    @ObservedObject var viewModel: EventsViewModel
    let courses: [TeamCourse]
    let onAddEvent: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: AppTheme.Spacing.small),
        GridItem(.flexible(), spacing: AppTheme.Spacing.small)
    ]

    public init(viewModel: EventsViewModel, courses: [TeamCourse], onAddEvent: @escaping () -> Void) {
        self.viewModel = viewModel
        self.courses = courses
        self.onAddEvent = onAddEvent
    }

    public var body: some View {
        Group {
            if viewModel.events.isEmpty && !viewModel.isLoading {
                EventsEmptyStateView(onAddEvent: onAddEvent)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: AppTheme.Spacing.small) {
                        ForEach(viewModel.events) { event in
                            EventCardView(event: event)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.medium)
                    .padding(.top, AppTheme.Spacing.small)
                    .padding(.bottom, AppTheme.Spacing.xxLarge)
                }
            }
        }
        .task {
            await viewModel.fetchEvents()
        }
    }
}
