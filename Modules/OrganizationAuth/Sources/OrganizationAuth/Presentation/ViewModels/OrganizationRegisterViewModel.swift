import Foundation
import Combine

@MainActor
public class OrganizationRegisterViewModel: ObservableObject {
    @Published public var request = RegisterOrganizationRequest()
    
    // UI State
    @Published public var currentStep: Int = 1
    @Published public var totalSteps: Int = 5 // 4 steps + 1 success
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    @Published public var isRegistered = false
    
    // Validations (Confirm password for step 1)
    @Published public var confirmPassword = ""
    
    private let useCase: OrganizationAuthUseCase
    
    public init(useCase: OrganizationAuthUseCase) {
        self.useCase = useCase
    }
    
    public func nextStep() {
        guard validateCurrentStep() else { return }
        
        if currentStep < 4 {
            withAnimation {
                currentStep += 1
            }
        } else if currentStep == 4 {
            submitRegistration()
        }
    }
    
    public func previousStep() {
        if currentStep > 1 {
            withAnimation {
                currentStep -= 1
            }
        }
    }
    
    private func validateCurrentStep() -> Bool {
        errorMessage = nil
        switch currentStep {
        case 1:
            if request.email.isEmpty || request.password.isEmpty {
                errorMessage = "Email and Password are required."
                return false
            }
            if request.password != confirmPassword {
                errorMessage = "Passwords do not match."
                return false
            }
        case 2:
            if request.organizationName.isEmpty || request.industryField.isEmpty {
                errorMessage = "Organization Name and Industry Field are required."
                return false
            }
        case 3:
            if request.targetAudience.isEmpty || request.numberOfMembers.isEmpty {
                errorMessage = "Target Audience and Number of Members are required."
                return false
            }
        case 4:
            if request.contactEmail.isEmpty || request.phoneNumber.isEmpty || request.address.isEmpty {
                errorMessage = "Contact Email, Phone Number, and Address are required."
                return false
            }
        default:
            break
        }
        return true
    }
    
    private func submitRegistration() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                _ = try await useCase.register(request: request)
                withAnimation {
                    self.currentStep = 5
                    self.isRegistered = true
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
}
