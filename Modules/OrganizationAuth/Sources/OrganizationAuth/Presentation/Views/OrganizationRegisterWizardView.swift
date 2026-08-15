import SwiftUI
import Common

public struct OrganizationRegisterWizardView: View {
    @StateObject private var viewModel: OrganizationRegisterViewModel
    public var onRegistrationComplete: () -> Void
    public var onBackToLogin: () -> Void
    
    public init(viewModel: OrganizationRegisterViewModel, onRegistrationComplete: @escaping () -> Void, onBackToLogin: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onRegistrationComplete = onRegistrationComplete
        self.onBackToLogin = onBackToLogin
    }
    
    public var body: some View {
        VStack {
            // Step Indicator Header
            StepIndicatorView(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)
                .padding(.vertical, AppTheme.Spacing.large)
            
            // Step Content
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(AppTheme.Colors.red100)
                            .font(AppTheme.textStyle(size: 14))
                            .padding(.horizontal)
                    }
                    
                    switch viewModel.currentStep {
                    case 1:
                        Step1AccountView(viewModel: viewModel)
                    case 2:
                        Step2BasicInfoView(viewModel: viewModel)
                    case 3:
                        Step3ServicesView(viewModel: viewModel)
                    case 4:
                        Step4ContactView(viewModel: viewModel)
                    case 5:
                        OrganizationSuccessView(onDashboardTap: onRegistrationComplete)
                    default:
                        EmptyView()
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.large)
            }
            
            // Footer Navigation Buttons
            if viewModel.currentStep < 5 {
                HStack {
                    Button(action: {
                        if viewModel.currentStep == 1 {
                            onBackToLogin()
                        } else {
                            viewModel.previousStep()
                        }
                    }) {
                        Text("Back")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.Colors.gray200)
                            .foregroundColor(AppTheme.Colors.white100)
                            .cornerRadius(AppTheme.radius.small)
                    }
                    
                    Button(action: {
                        viewModel.nextStep()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.white100))
                            } else {
                                Text(viewModel.currentStep == 4 ? "Submit" : "Next")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.purple100)
                        .foregroundColor(AppTheme.Colors.white100)
                        .cornerRadius(AppTheme.radius.small)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Step Indicator
struct StepIndicatorView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...totalSteps, id: \.self) { step in
                ZStack {
                    Circle()
                        .fill(step <= currentStep ? AppTheme.Colors.purple100 : AppTheme.Colors.gray200)
                        .frame(width: 30, height: 30)
                    
                    Text("\(step)")
                        .foregroundColor(AppTheme.Colors.white100)
                        .font(AppTheme.textStyle(size: 14, weight: .bold))
                }
                
                if step < totalSteps {
                    Rectangle()
                        .fill(step < currentStep ? AppTheme.Colors.purple100 : AppTheme.Colors.gray200)
                        .frame(height: 2)
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.large)
    }
}

// MARK: - Sub Views for Steps
struct Step1AccountView: View {
    @ObservedObject var viewModel: OrganizationRegisterViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("Account Credentials")
                .font(AppTheme.textStyle(size: 24, weight: .bold))
            
            TextField("Email Address", text: $viewModel.request.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $viewModel.request.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct Step2BasicInfoView: View {
    @ObservedObject var viewModel: OrganizationRegisterViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("Basic Info")
                .font(AppTheme.textStyle(size: 24, weight: .bold))
            
            TextField("Organization Name", text: $viewModel.request.organizationName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Industry Field", text: $viewModel.request.industryField)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Description (Optional)", text: $viewModel.request.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct Step3ServicesView: View {
    @ObservedObject var viewModel: OrganizationRegisterViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("Services & Audience")
                .font(AppTheme.textStyle(size: 24, weight: .bold))
            
            TextField("Target Audience", text: $viewModel.request.targetAudience)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Simplified for list
            TextField("Number of Members", text: $viewModel.request.numberOfMembers)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
        }
    }
}

struct Step4ContactView: View {
    @ObservedObject var viewModel: OrganizationRegisterViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("Contact & Location")
                .font(AppTheme.textStyle(size: 24, weight: .bold))
            
            TextField("Contact Email", text: $viewModel.request.contactEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            TextField("Phone Number", text: $viewModel.request.phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.phonePad)
            
            TextField("Website URL (Optional)", text: $viewModel.request.websiteURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.URL)
                .autocapitalization(.none)
            
            TextField("Address", text: $viewModel.request.address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Registration Number (Optional)", text: $viewModel.request.registrationNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Document URL", text: $viewModel.request.documentURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
