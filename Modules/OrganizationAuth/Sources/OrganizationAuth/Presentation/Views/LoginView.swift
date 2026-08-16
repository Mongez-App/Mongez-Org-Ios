import SwiftUI
import Common

public struct LoginView: View {
    @StateObject private var viewModel: AuthViewModel

    public var onNavigateToRegister: () -> Void
    public var onLoginSuccess: () -> Void
    public var onForgotPassword: () -> Void
    public var onGoogleSignIn: () -> Void

    public init(
        viewModel: AuthViewModel,
        onNavigateToRegister: @escaping () -> Void = {},
        onLoginSuccess: @escaping () -> Void = {},
        onForgotPassword: @escaping () -> Void = {},
        onGoogleSignIn: @escaping () -> Void = {}
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onNavigateToRegister = onNavigateToRegister
        self.onLoginSuccess = onLoginSuccess
        self.onForgotPassword = onForgotPassword
        self.onGoogleSignIn = onGoogleSignIn
    }

    public var body: some View {
        ZStack {
            AppTheme.Colors.white100.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                        illustration

                        Text("Welcome Back")
                            .font(AppTheme.textStyle(size: 28, weight: .bold))
                            .foregroundColor(AppTheme.Colors.black100)

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
                            placeholder: "Enter your password",
                            text: $viewModel.password,
                            isVisible: $viewModel.isPasswordVisible,
                            icon: "password"
                        )

                        Button(action: onForgotPassword) {
                            Text("Forgot Password?")
                                .font(AppTheme.textStyle(size: 13, weight: .medium))
                                .foregroundColor(AppTheme.Colors.purple200)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)

                        signInButton

                        divider

                        googleButton
                    }
                    .padding(AppTheme.Spacing.large)
                    .padding(.top, AppTheme.Spacing.xSmall)
                }

                footer
            }
            .disabled(viewModel.isLoading)
            .opacity(viewModel.isLoading ? 0.8 : 1.0)
        }
        .navigationBarHidden(true)
        .alert(isPresented: errorBinding) {
            Alert(
                title: Text("Alert"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: viewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                onLoginSuccess()
            }
        }
    }

    private var illustration: some View {
        Image("Login-illustration", bundle: .module)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .padding(.top, AppTheme.Spacing.small)
    }

    private var signInButton: some View {
        Button {
            viewModel.login()
        } label: {
            HStack(spacing: AppTheme.Spacing.xxSmall) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.white100))
                } else {
                    Text("Sign In")
                }
            }
            .font(AppTheme.textStyle(size: 16, weight: .bold))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(AppTheme.Colors.purple200)
            .foregroundColor(AppTheme.Colors.white100)
            .cornerRadius(AppTheme.radius.meduim)
        }
        .padding(.top, AppTheme.Spacing.xSmall)
    }

    private var divider: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.2))

            Text("or")
                .font(AppTheme.textStyle(size: 12))
                .foregroundColor(AppTheme.Colors.gray300)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.2))
        }
        .padding(.vertical, AppTheme.Spacing.xSmall)
    }

    private var googleButton: some View {
        Button(action: onGoogleSignIn) {
            HStack(spacing: AppTheme.Spacing.xxSmall) {
                googleIcon

                Text("Sign in with Google")
                    .font(AppTheme.textStyle(size: 15, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                    .stroke(AppTheme.Colors.gray200, lineWidth: 1)
            )
            .foregroundColor(AppTheme.Colors.black100)
        }
    }

    private var googleIcon: some View {
        Image("google_logo", bundle: .module)
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
    }

    private var footer: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .font(AppTheme.textStyle(size: 13))
                .foregroundColor(AppTheme.Colors.gray300)

            Button(action: onNavigateToRegister) {
                Text("Sign up")
                    .font(AppTheme.textStyle(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.Colors.purple200)
            }
        }
        .padding(.top, AppTheme.Spacing.small)
        .padding(.bottom, AppTheme.Spacing.large)
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel(useCase: AuthUseCaseImpl(repository: OrganizationAuthRepositoryImpl(networkService: OrganizationAuthNetworkServiceImpl()))))
}
