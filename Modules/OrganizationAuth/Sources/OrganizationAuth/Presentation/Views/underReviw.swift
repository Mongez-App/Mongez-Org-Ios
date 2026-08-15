//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 15/08/2026.
//

import SwiftUI
import Common

public struct UnderReviewView: View {
    public var currentStep: Int
    public var totalSteps: Int
    public var onDoneTap: () -> Void

    public init(
        currentStep: Int = 4,
        totalSteps: Int = 5,
        onDoneTap: @escaping () -> Void = {}
    ) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.onDoneTap = onDoneTap
    }

    public var body: some View {
        VStack(spacing: 0) {
            StepProgressIndicator(currentStep: currentStep, totalSteps: totalSteps)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.small)

            Spacer()

            VStack(spacing: AppTheme.Spacing.large) {
                Image(systemName: "clock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(AppTheme.Colors.purple200)

                Text("Under Review")
                    .font(AppTheme.textStyle(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)

                Text("Your request has been submitted successfully and is currently under review. We will notify you once approved.")
                    .font(AppTheme.textStyle(size: 16))
                    .foregroundColor(AppTheme.Colors.gray300)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppTheme.Spacing.xLarge)

            Spacer()

            Button(action: onDoneTap) {
                Text("Done")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppTheme.Colors.purple200)
                    .foregroundColor(AppTheme.Colors.white100)
                    .cornerRadius(AppTheme.radius.meduim)
            }
            .padding(.horizontal, AppTheme.Spacing.large)
            .padding(.bottom, AppTheme.Spacing.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
