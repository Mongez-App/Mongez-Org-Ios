//
//  MemberCardView.swift
//  Courses
//

import Foundation
import SwiftUI
import Common

public struct MemberCardView: View {
    let member: TeamMember
    let onAccept: (() -> Void)?
    let onDecline: (() -> Void)?
    
    public init(member: TeamMember, onAccept: (() -> Void)? = nil, onDecline: (() -> Void)? = nil) {
        self.member = member
        self.onAccept = onAccept
        self.onDecline = onDecline
    }
    
    public var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            // Avatar
            Circle()
                .fill(member.avatarSwiftUIColor)
                .frame(width: 60, height: 60)
                .overlay(
                    Text(member.avatarInitials)
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.white100)
                )
            
            // Name
            Text(member.name)
                .font(AppTheme.textStyle(size: 16, weight: .medium))
                .foregroundColor(AppTheme.Colors.black100)
                .lineLimit(1)
            
            Spacer()
            
            // Actions (only for pending members)
            if member.status == .pending {
                HStack(spacing: AppTheme.Spacing.xSmall) {
                    if let onDecline = onDecline {
                        Button(action: onDecline) {
                            Text("Decline")
                                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.red100)
                        }
                    }
                    
                    if onAccept != nil && onDecline != nil {
                        Text("|")
                            .font(AppTheme.textStyle(size: 14))
                            .foregroundColor(AppTheme.Colors.black100)
                    }
                    
                    if let onAccept = onAccept {
                        Button(action: onAccept) {
                            Text("Accept")
                                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.green100)
                        }
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.xSmall)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .fill(AppTheme.Colors.white100)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                )
        )
    }
}
