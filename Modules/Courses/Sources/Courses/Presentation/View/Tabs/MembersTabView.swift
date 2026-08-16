//
//  MembersTabView.swift
//  Courses
//

import Foundation
import SwiftUI
import Common

public struct MembersTabView: View {
    @ObservedObject var viewModel: TeamCoursesViewModel
    
    public init(viewModel: TeamCoursesViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                
                // Pending Members Section
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    Text("Pending Members")
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                    
                    if viewModel.isMembersLoading && viewModel.pendingMembers.isEmpty && viewModel.teamMembers.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, AppTheme.Spacing.large)
                    } else if viewModel.pendingMembers.isEmpty {
                        Text("No Pending Members for the Current time")
                            .font(AppTheme.textStyle(size: 14))
                            .foregroundColor(AppTheme.Colors.gray300)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, AppTheme.Spacing.medium)
                    } else {
                        ForEach(viewModel.pendingMembers) { member in
                            MemberCardView(
                                member: member,
                                onAccept: {
                                    Task { await viewModel.acceptMember(memberId: member.id) }
                                },
                                onDecline: {
                                    Task { await viewModel.declineMember(memberId: member.id) }
                                }
                            )
                        }
                    }
                }
                
                // Team Members Section
                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                    Text("Team Members")
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                    
                    if viewModel.isMembersLoading && viewModel.pendingMembers.isEmpty && viewModel.teamMembers.isEmpty {
                        // Already showing loading in pending section
                    } else if viewModel.teamMembers.isEmpty {
                        MembersEmptyStateView()
                    } else {
                        ForEach(viewModel.teamMembers) { member in
                            MemberCardView(member: member)
                        }
                    }
                }
                
                Spacer(minLength: AppTheme.Spacing.xxLarge)
            }
            .padding(.horizontal, AppTheme.Spacing.medium)
        }
        .task {
            await viewModel.fetchMembers()
        }
    }
}
