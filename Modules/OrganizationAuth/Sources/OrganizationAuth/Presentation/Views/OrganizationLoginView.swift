import SwiftUI
import Common

public struct OrganizationLoginView: View {
    @StateObject private var viewModel: OrganizationLoginViewModel
    public var onNavigateToRegister: () -> Void
    public var onLoginSuccess: () -> Void
    
    public init(viewModel: OrganizationLoginViewModel, onNavigateToRegister: @escaping () -> Void, onLoginSuccess: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onNavigateToRegister = onNavigateToRegister
        self.onLoginSuccess = onLoginSuccess
    }
    
    public var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Text("Login")
                .font(AppTheme.textStyle(size: 32, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
                .padding(.top, 40)
            
            VStack(spacing: AppTheme.Spacing.medium) {
                // Email Field
                HStack {
                    Image("mail", bundle: .main) // Adjust bundle based on where assets are
                        .foregroundColor(AppTheme.Colors.gray200)
                    TextField("Email Address", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding()
                .background(AppTheme.Colors.gray100)
                .cornerRadius(AppTheme.radius.small)
                
                // Password Field
                HStack {
                    Image("password", bundle: .main)
                        .foregroundColor(AppTheme.Colors.gray200)
                    SecureField("Password", text: $viewModel.password)
                }
                .padding()
                .background(AppTheme.Colors.gray100)
                .cornerRadius(AppTheme.radius.small)
            }
            .padding(.horizontal, AppTheme.Spacing.large)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(AppTheme.Colors.red100)
                    .font(AppTheme.textStyle(size: 14))
            }
            
            Button(action: {
                viewModel.login()
            }) {
                HStack {
                    Spacer()
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.white100))
                    } else {
                        Text("Login")
                            .font(AppTheme.textStyle(size: 16, weight: .bold))
                    }
                    Spacer()
                }
                .padding()
                .background(AppTheme.Colors.purple100)
                .foregroundColor(AppTheme.Colors.white100)
                .cornerRadius(AppTheme.radius.small)
            }
            .padding(.horizontal, AppTheme.Spacing.large)
            
            Button(action: onNavigateToRegister) {
                Text("Don't have an account? Register")
                    .font(AppTheme.textStyle(size: 14))
                    .foregroundColor(AppTheme.Colors.purple100)
            }
            
            Spacer()
        }
        .onChange(of: viewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                onLoginSuccess()
            }
        }
    }
}
