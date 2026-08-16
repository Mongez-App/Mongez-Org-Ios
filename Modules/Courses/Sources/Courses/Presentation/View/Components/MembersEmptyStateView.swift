//
//  MembersEmptyStateView.swift
//  Courses
//

import Foundation
import SwiftUI
import Common

public struct MembersEmptyStateView: View {
    public init() {}
    
    public var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            Image("empty_team_member", bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 75)
                .padding(.bottom, AppTheme.Spacing.small)
            
            Text("No team members added yet")
                .font(AppTheme.textStyle(size: 14))
                .foregroundColor(AppTheme.Colors.gray300)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppTheme.Spacing.xxLarge)
    }
}
