//
//  File.swift
//
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
import SwiftUI
import Common

public struct DashboardView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Spacer()

            Image("dashboard_illustration")
                .resizable()
                .scaledToFit()
                .frame(width: 260, height: 260)

            Text("Dashboard is Coming Soon")
                .font(AppTheme.textStyle(size: 18, weight: .bold))
                .foregroundColor(AppTheme.Colors.gray300)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.white100.ignoresSafeArea())
    }
}
