import SwiftUI
import Common

public struct OrganizationLoginView: View {
    
    private enum Field: Hashable {
        case email, password
    }
    
    @StateObject private var viewModel: OrganizationLoginViewModel
    @FocusState private var focusedField: Field?
    public var onNavigateToRegister: () -> Void
    public var onLoginSuccess: () -> Void
    
    public init(viewModel: OrganizationLoginViewModel, onNavigateToRegister: @escaping () -> Void, onLoginSuccess: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onNavigateToRegister = onNavigateToRegister
        self.onLoginSuccess = onLoginSuccess
    }
    
    private var secondaryTextColor: Color {
        AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.55)
    }
    
    public var body: some View {
        ZStack {
            AppTheme.Colors.white100.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back")
                                .font(AppTheme.textStyle(size: 28, weight: .bold))
                                .foregroundColor(AppTheme.Colors.black100)
                            Text("Manage your organization effortlessly")
                                .font(AppTheme.textStyle(size: 14))
                                .foregroundColor(secondaryTextColor)
                        }
                        .padding(.bottom, AppTheme.Spacing.small)
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.black100)
                            HStack {
                                Image("email")
                                    .foregroundColor(AppTheme.Colors.gray300)
                                TextField("JohnDoe@gmail.com", text: $viewModel.email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($focusedField, equals: .email)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .padding(.horizontal, AppTheme.Spacing.xSmall)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .stroke(borderColor(for: .email), lineWidth: borderWidth(for: .email))
                            )
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.black100)
                            HStack {
                                Image("password")
                                    .foregroundColor(AppTheme.Colors.gray300)
                                Group {
                                    if viewModel.isPasswordVisible {
                                        TextField("••••••••", text: $viewModel.password)
                                    } else {
                                        SecureField("••••••••", text: $viewModel.password)
                                    }
                                }
                                .focused($focusedField, equals: .password)
                                
                                Button {
                                    viewModel.isPasswordVisible.toggle()
                                } label: {
                                    Image(viewModel.isPasswordVisible ? "eye_shown" : "eye_hidden")
                                        .foregroundColor(secondaryTextColor)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .padding(.horizontal, AppTheme.Spacing.xSmall)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .stroke(borderColor(for: .password), lineWidth: borderWidth(for: .password))
                            )
                        }
                        
                        // Forgot Password
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {}
                                .font(AppTheme.textStyle(size: 13, weight: .medium))
                                .foregroundColor(AppTheme.Colors.purple200)
                        }
                        
                        // Primary Button
                        Button {
                            viewModel.login()
                        } label: {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.white100))
                                } else {
                                    Text("Sign In")
                                        .font(AppTheme.textStyle(size: 16, weight: .bold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(AppTheme.Colors.purple200)
                            .foregroundColor(AppTheme.Colors.white100)
                            .cornerRadius(AppTheme.radius.meduim)
                        }
                        .padding(.top, AppTheme.Spacing.xSmall)
                        
                        // Or divider
                        HStack {
                            Rectangle().frame(height: 1).foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.2))
                            Text("or")
                                .font(AppTheme.textStyle(size: 12))
                                .foregroundColor(secondaryTextColor)
                            Rectangle().frame(height: 1).foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.2))
                        }
                        .padding(.vertical, AppTheme.Spacing.xSmall)
                        
                        // Google Button
                        Button {} label: {
                            HStack {
                                Image("google_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                Text("Continue with Google")
                                    .font(AppTheme.textStyle(size: 15, weight: .medium))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                                    .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.4))
                            )
                            .foregroundColor(AppTheme.Colors.black100)
                        }
                    }
                    .padding(AppTheme.Spacing.large)
                }
                
                // Switch mode footer
                HStack {
                    Spacer()
                    Text("Don't have an account?")
                        .font(AppTheme.textStyle(size: 13))
                        .foregroundColor(secondaryTextColor)
                    Button("Register") {
                        onNavigateToRegister()
                    }
                    .font(AppTheme.textStyle(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.Colors.purple200)
                    Spacer()
                }
                .padding(.top, AppTheme.Spacing.small)
                .padding(.bottom, 32)
            }
            .disabled(viewModel.isLoading)
            .opacity(viewModel.isLoading ? 0.8 : 1.0)
        }
        .alert(isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Alert(
                title: Text("Alert"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: viewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated { onLoginSuccess() }
        }
    }
    
    private func borderColor(for field: Field) -> Color {
        if focusedField == field {
            return AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.4)
        }
        return AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.55)
    }
    
    private func borderWidth(for field: Field) -> CGFloat {
        focusedField == field ? 1.5 : 1
    }
}
