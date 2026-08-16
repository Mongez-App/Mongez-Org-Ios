import SwiftUI
import Common

public struct VerifiedView: View {
    public var currentStep: Int
    public var totalSteps: Int
    public var onDashboardTap: () -> Void

    public init(
        currentStep: Int = 5,
        totalSteps: Int = 5,
        onDashboardTap: @escaping () -> Void = {}
    ) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.onDashboardTap = onDashboardTap
    }

    public var body: some View {
        VStack(spacing: 0) {
            StepProgressIndicator(currentStep: currentStep, totalSteps: totalSteps)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.small)

            Spacer()

            VStack(spacing: AppTheme.Spacing.large) {
                Image("verified_illustration", bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)

                Text("Verified!")
                    .font(AppTheme.textStyle(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)

                Text("Congratulations! Your request has been reviewed and accepted.")
                    .font(AppTheme.textStyle(size: 16))
                    .foregroundColor(AppTheme.Colors.gray300)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppTheme.Spacing.xLarge)

            Spacer()

            Button(action: onDashboardTap) {
                Text("Go to Dashboard")
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

struct VerifiedView_Previews: PreviewProvider {
    static var previews: some View {
    VerifiedView()
}
}
