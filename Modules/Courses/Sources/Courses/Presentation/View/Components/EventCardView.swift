//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common

public struct EventCardView: View {
    let event: TeamEvent

    public init(event: TeamEvent) {
        self.event = event
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            HStack(alignment: .top, spacing: AppTheme.Spacing.xxSmall) {
                Text(event.courseName)
                    .font(AppTheme.textStyle(size: 12, weight: .semibold))
                    .foregroundColor(event.eventType.color)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Spacer(minLength: AppTheme.Spacing.xxxSmall)

                RoundedRectangle(cornerRadius: 8)
                    .fill(AppTheme.Colors.changeOpacity(color: event.eventType.color, opacity: 0.15))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "calendar")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(event.eventType.color)
                    )
            }

            Text(event.eventType.rawValue)
                .font(AppTheme.textStyle(size: 16, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
                .lineLimit(1)

            Spacer(minLength: AppTheme.Spacing.xxxSmall)

            Text(event.daysLeftText)
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(event.eventType.color)
        }
        .padding(AppTheme.Spacing.small)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 104)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .fill(AppTheme.Colors.white100)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .stroke(event.eventType.color.opacity(0.5), lineWidth: 1.2)
        )
    }
}
