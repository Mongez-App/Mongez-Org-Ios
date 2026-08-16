//
//  File.swift
//
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
import SwiftUI
import Common

public struct LogoutConfirmationView: View {
    let onLogout: () -> Void
    let onCancel: () -> Void

    public init(onLogout: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.onLogout = onLogout
        self.onCancel = onCancel
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onCancel() }

            VStack(spacing: AppTheme.Spacing.medium) {
                Circle()
                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.red100, opacity: 0.15))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(AppTheme.Colors.red100)
                    )

                VStack(spacing: AppTheme.Spacing.xxSmall) {
                    Text("Are sure you want to log out?")
                        .font(AppTheme.textStyle(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                        .multilineTextAlignment(.center)

                    Text("You will need to enter your username and password to sign back in.")
                        .font(AppTheme.textStyle(size: 13))
                        .foregroundColor(AppTheme.Colors.gray300)
                        .multilineTextAlignment(.center)
                }

                HStack(spacing: AppTheme.Spacing.small) {
                    Button(action: onLogout) {
                        Text("Logout")
                            .font(AppTheme.textStyle(size: 15, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.red100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                            )
                    }

                    Button(action: onCancel) {
                        Text("Cancel")
                            .font(AppTheme.textStyle(size: 15, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.white100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .fill(AppTheme.Colors.purple200)
                            )
                    }
                }
            }
            .padding(AppTheme.Spacing.large)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                    .fill(AppTheme.Colors.white100)
                    .appShadow(opacity: 0.15, radius: 20)
            )
            .padding(.horizontal, AppTheme.Spacing.xLarge)
        }
    }
}
