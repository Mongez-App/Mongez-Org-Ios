import SwiftUI
import Common

public struct CreateAccountView: View {
    @ObservedObject var viewModel: AuthViewModel
    public var onBack: () -> Void

    public init(viewModel: AuthViewModel, onBack: @escaping () -> Void = {}) {
        self.viewModel = viewModel
        self.onBack = onBack
    }

    public var body: some View {
        VStack(spacing: 0) {
            topBar

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                    StepProgressIndicator(
                        currentStep: viewModel.currentStep,
                        totalSteps: viewModel.totalSteps
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.small)

                    Image("Sign up-illustration", bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)

                    Text("Create Account")
                        .font(AppTheme.textStyle(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)

                    CustomTextField(
                        title: "Organization Name",
                        placeholder: "Enter organization name",
                        text: $viewModel.orgName,
                        icon: "name"
                    )

                    CustomTextField(
                        title: "Email",
                        placeholder: "Enter your email",
                        text: $viewModel.email,
                        icon: "email",
                        keyboardType: .emailAddress,
                        textContentType: .emailAddress,
                        autocapitalization: .never
                    )

                    SecureInputView(
                        title: "Password",
                        placeholder: "Create a password",
                        text: $viewModel.password,
                        isVisible: $viewModel.isPasswordVisible,
                        icon: "password"
                    )

                    SecureInputView(
                        title: "Confirm Password",
                        placeholder: "Confirm your password",
                        text: $viewModel.confirmPassword,
                        isVisible: $viewModel.isConfirmPasswordVisible,
                        icon: "password"
                    )

                    if let error = viewModel.errorMessage {
                        errorBanner(error)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.large)
                .padding(.bottom, AppTheme.Spacing.large)
            }

            nextButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var topBar: some View {
        HStack {
            Button(action: onBack) {
                Image("back", bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(AppTheme.Colors.gray100))
            }
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.top, AppTheme.Spacing.xSmall)
    }

    private var nextButton: some View {
        Button {
            viewModel.nextStep()
        } label: {
            Text("Next")
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

    private func errorBanner(_ message: String) -> some View {
        HStack(spacing: AppTheme.Spacing.xxSmall) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(AppTheme.Colors.red100)

            Text(message)
                .font(AppTheme.textStyle(size: 13))
                .foregroundColor(AppTheme.Colors.red100)
        }
        .padding(AppTheme.Spacing.xSmall)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .fill(AppTheme.Colors.red100.opacity(0.1))
        )
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
    CreateAccountView(viewModel: AuthViewModel(useCase: AuthUseCaseImpl(repository: OrganizationAuthRepositoryImpl(networkService: OrganizationAuthNetworkServiceImpl()))))
}
}
