//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common

public struct EventConfirmationView: View {
    let onOk: () -> Void

    public init(onOk: @escaping () -> Void) {
        self.onOk = onOk
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: AppTheme.Spacing.medium) {
                Text("Confirmation")
                    .font(AppTheme.textStyle(size: 18, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)

                Text("Your Event Has Been Added Successfully")
                    .font(AppTheme.textStyle(size: 14))
                    .foregroundColor(AppTheme.Colors.gray300)
                    .multilineTextAlignment(.center)

                Button(action: onOk) {
                    Text("OK")
                        .font(AppTheme.textStyle(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.white100)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                .fill(AppTheme.Colors.purple200)
                        )
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
