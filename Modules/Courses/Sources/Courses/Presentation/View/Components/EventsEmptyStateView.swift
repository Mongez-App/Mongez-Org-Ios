//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import Common
import SwiftUI

public struct EventsEmptyStateView: View {
    let onAddEvent: () -> Void

    public init(onAddEvent: @escaping () -> Void) {
        self.onAddEvent = onAddEvent
    }

    public var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            Spacer()

            Circle()
                .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.15))
                .frame(width: 120, height: 120)
                .overlay(
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(AppTheme.Colors.purple200)
                )

            VStack(spacing: AppTheme.Spacing.xxSmall) {
                Text("No Events Yet")
                    .font(AppTheme.textStyle(size: 20, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)

                Text("You don't have scheduled events for this\nteam")
                    .font(AppTheme.textStyle(size: 14))
                    .foregroundColor(AppTheme.Colors.gray300)
                    .multilineTextAlignment(.center)
            }

            Button(action: onAddEvent) {
                Text("Let's Add an Event")
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
