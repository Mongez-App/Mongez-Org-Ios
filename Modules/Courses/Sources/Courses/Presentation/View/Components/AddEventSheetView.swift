//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common

public struct AddEventSheetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: EventsViewModel
    let courses: [TeamCourse]

    @State private var selectedCourse: TeamCourse?
    @State private var selectedEventType: EventType?
    @State private var eventDate: Date?
    @State private var showDatePicker = false
    @State private var showConfirmation = false

    public init(viewModel: EventsViewModel, courses: [TeamCourse]) {
        self.viewModel = viewModel
        self.courses = courses
    }

    private var dateText: String {
        guard let eventDate = eventDate else { return "DD/MM/YYYY" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: eventDate)
    }

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Capsule()
                    .fill(AppTheme.Colors.gray200)
                    .frame(width: 40, height: 4)
                    .padding(.top, AppTheme.Spacing.small)

                Text("Add Event")
                    .font(AppTheme.textStyle(size: 18, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .padding(.vertical, AppTheme.Spacing.medium)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                            Text("Event Course")
                                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.black100)

                            Menu {
                                ForEach(courses) { course in
                                    Button(course.title) { selectedCourse = course }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCourse?.title ?? "Choose a course")
                                        .font(AppTheme.textStyle(size: 14))
                                        .foregroundColor(selectedCourse == nil ? AppTheme.Colors.gray300 : AppTheme.Colors.black100)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppTheme.Colors.gray300)
                                }
                                .padding(AppTheme.Spacing.small)
                                .frame(height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                        .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                                )
                            }
                        }

                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                            Text("Event Type")
                                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.black100)

                            Menu {
                                ForEach(EventType.allCases) { type in
                                    Button(type.rawValue) { selectedEventType = type }
                                }
                            } label: {
                                HStack {
                                    Text(selectedEventType?.rawValue ?? "Choose a event type")
                                        .font(AppTheme.textStyle(size: 14))
                                        .foregroundColor(selectedEventType == nil ? AppTheme.Colors.gray300 : AppTheme.Colors.black100)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppTheme.Colors.gray300)
                                }
                                .padding(AppTheme.Spacing.small)
                                .frame(height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                        .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                                )
                            }
                        }

                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                            Text("Event Date")
                                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.black100)

                            Button(action: { showDatePicker = true }) {
                                HStack {
                                    Text(dateText)
                                        .font(AppTheme.textStyle(size: 14))
                                        .foregroundColor(eventDate == nil ? AppTheme.Colors.gray300 : AppTheme.Colors.black100)
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .foregroundColor(AppTheme.Colors.purple200)
                                }
                                .padding(AppTheme.Spacing.small)
                                .frame(height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                        .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(AppTheme.Spacing.small)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(AppTheme.textStyle(size: 12))
                        .foregroundColor(AppTheme.Colors.red100)
                        .padding(.horizontal, AppTheme.Spacing.small)
                }

                Button(action: {
                    Task {
                        guard let selectedCourse, let selectedEventType, let eventDate else { return }
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"

                        let success = await viewModel.createEvent(
                            courseId: selectedCourse.id,
                            eventType: selectedEventType,
                            eventDate: formatter.string(from: eventDate)
                        )

                        if success {
                            showConfirmation = true
                        }
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.white100))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(RoundedRectangle(cornerRadius: AppTheme.radius.small).fill(AppTheme.Colors.purple200.opacity(0.5)))
                    } else {
                        Text("Add Event")
                            .font(AppTheme.textStyle(size: 16, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.white100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(RoundedRectangle(cornerRadius: AppTheme.radius.small).fill(AppTheme.Colors.purple200))
                    }
                }
                .padding(AppTheme.Spacing.small)
                .disabled(selectedCourse == nil || selectedEventType == nil || eventDate == nil || viewModel.isLoading)
                .background(AppTheme.Colors.white100.ignoresSafeArea())
            }

            if showConfirmation {
                EventConfirmationView {
                    showConfirmation = false
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            VStack(spacing: 0) {
                DatePicker(
                    "Event Date",
                    selection: Binding(get: { eventDate ?? Date() }, set: { eventDate = $0 }),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(AppTheme.Colors.purple200)
                .padding()

                Button(action: { showDatePicker = false }) {
                    Text("Done")
                        .font(AppTheme.textStyle(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.white100)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(RoundedRectangle(cornerRadius: AppTheme.radius.small).fill(AppTheme.Colors.purple200))
                }
                .padding(AppTheme.Spacing.small)
            }
            .presentationDetents([.medium])
        }
    }
}
