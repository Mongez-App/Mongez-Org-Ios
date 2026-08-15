import SwiftUI
import Common

public struct StepProgressIndicator: View {
    private let currentStep: Int
    private let totalSteps: Int

    public init(currentStep: Int, totalSteps: Int = 5) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
    }

    private var activeColor: Color {
        AppTheme.Colors.purple200
    }

    private var inactiveBorderColor: Color {
        AppTheme.Colors.gray300
    }

    private var connectorColor: Color {
        AppTheme.Colors.gray300
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(1...totalSteps, id: \.self) { step in
                stepCircle(step)
                if step < totalSteps {
                    connectorLine(after: step)
                }
            }
        }
    }

    private func stepCircle(_ step: Int) -> some View {
        let isActive = step <= currentStep

        return ZStack {
            Circle()
                .fill(isActive ? activeColor : AppTheme.Colors.white100)
                .frame(width: 32, height: 32)

            Circle()
                .stroke(isActive ? activeColor : inactiveBorderColor, lineWidth: 1.5)
                .frame(width: 32, height: 32)

            Text("\(step)")
                .font(AppTheme.textStyle(size: 14, weight: .bold))
                .foregroundColor(isActive ? AppTheme.Colors.white100 : activeColor)
        }
    }

    private func connectorLine(after step: Int) -> some View {
        Rectangle()
            .fill(step < currentStep ? activeColor : connectorColor)
            .frame(height: 1.5)
            .padding(.horizontal, AppTheme.Spacing.xxSmall)
    }
}

#Preview {
    VStack(spacing: 20) {
        StepProgressIndicator(currentStep: 1)
        StepProgressIndicator(currentStep: 3)
        StepProgressIndicator(currentStep: 5)
    }
    .padding()
}
