import SwiftUI
import Common

public struct RegistrationWizardView: View {
    @StateObject private var viewModel: AuthViewModel
    public var onBackToLogin: () -> Void
    public var onRegistrationComplete: () -> Void

    public init(
        viewModel: AuthViewModel,
        onBackToLogin: @escaping () -> Void = {},
        onRegistrationComplete: @escaping () -> Void = {}
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onBackToLogin = onBackToLogin
        self.onRegistrationComplete = onRegistrationComplete
    }

    public var body: some View {
        ZStack {
            AppTheme.Colors.white100.ignoresSafeArea()

            switch viewModel.currentStep {
            case 1:
                CreateAccountView(viewModel: viewModel, onBack: onBackToLogin)
            case 2:
                OrganizationDetailsView(viewModel: viewModel)
            case 3:
                ContactAndLocationView(viewModel: viewModel)
            case 5:
                VerifiedView(
                    currentStep: viewModel.currentStep,
                    totalSteps: viewModel.totalSteps,
                    onDashboardTap: onRegistrationComplete
                )
            default:
                EmptyView()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    RegistrationWizardView(viewModel: AuthViewModel(useCase: AuthUseCaseImpl(repository: OrganizationAuthRepositoryImpl(networkService: OrganizationAuthNetworkServiceImpl()))))
}
