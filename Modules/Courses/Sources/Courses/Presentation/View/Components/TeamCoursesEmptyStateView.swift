//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import Common
import SwiftUI

public struct TeamCoursesEmptyStateView: View {
    let onAddCourse: () -> Void
    
    public init(onAddCourse: @escaping () -> Void) {
        self.onAddCourse = onAddCourse
    }
    
    public var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            Spacer()
            
            Circle()
                .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.15))
                .frame(width: 120, height: 120)
                .overlay(
                    Image(systemName: "book.closed.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(AppTheme.Colors.purple200)
                )
            
            VStack(spacing: AppTheme.Spacing.xxSmall) {
                Text("No Courses Yet")
                    .font(AppTheme.textStyle(size: 20, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                Text("You haven't added any courses yet for this\nteam")
                    .font(AppTheme.textStyle(size: 14))
                    .foregroundColor(AppTheme.Colors.gray300)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onAddCourse) {
                Text("Add Your First Course")
                    .font(AppTheme.textStyle(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.white100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .fill(AppTheme.Colors.purple200)
                    )
            }
            .padding(.horizontal, AppTheme.Spacing.xLarge)
            
            Spacer()
        }
    }
}
