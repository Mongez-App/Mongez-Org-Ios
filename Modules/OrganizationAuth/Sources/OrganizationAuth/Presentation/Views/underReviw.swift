import SwiftUI
import Common

public struct UnderReviewView: View {
    public var currentStep: Int
    public var totalSteps: Int
    public var onDoneTap: () -> Void
    public var onApproved: () -> Void

    @State private var isSimulating = false
    @State private var dotCount = 0
    private let timer = Timer.publish(every: 0.6, on: .main, in: .common).autoconnect()

    public init(
        currentStep: Int = 4,
        totalSteps: Int = 5,
        onDoneTap: @escaping () -> Void = {},
        onApproved: @escaping () -> Void = {}
    ) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.onDoneTap = onDoneTap
        self.onApproved = onApproved
    }

    private var dots: String {
        String(repeating: ".", count: dotCount + 1)
    }

    public var body: some View {
        VStack(spacing: 0) {
            StepProgressIndicator(currentStep: currentStep, totalSteps: totalSteps)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.small)

            Spacer()

            VStack(spacing: AppTheme.Spacing.large) {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.changeOpacity(
                            color: AppTheme.Colors.purple200,
                            opacity: 0.1
                        ))
                        .frame(width: 160, height: 160)

                    Image(systemName: "clock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(AppTheme.Colors.purple200)
                }

                Text("Under Review")
                    .font(AppTheme.textStyle(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)

                if isSimulating {
                    HStack(spacing: 6) {
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: AppTheme.Colors.purple200)
                            )
                            .scaleEffect(0.8)

                        Text("Reviewing your application\(dots)")
                            .font(AppTheme.textStyle(size: 14, weight: .medium))
                            .foregroundColor(AppTheme.Colors.purple200)
                            .animation(.none, value: dots)
                    }
                    .padding(.horizontal, AppTheme.Spacing.small)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(AppTheme.Colors.changeOpacity(
                                color: AppTheme.Colors.purple200,
                                opacity: 0.08
                            ))
                    )
                } else {
                    Text("Your request has been submitted successfully and is currently under review. We will notify you once approved.")
                        .font(AppTheme.textStyle(size: 16))
                        .foregroundColor(AppTheme.Colors.gray300)
                        .multilineTextAlignment(.center)
                }
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
        .onAppear {
            startFakeReview()
        }
        .onReceive(timer) { _ in
            guard isSimulating else { return }
            dotCount = (dotCount + 1) % 3
        }
    }

    private func startFakeReview() {
        isSimulating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation(.easeInOut(duration: 0.4)) {
                isSimulating = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onApproved()
            }
        }
    }
}
