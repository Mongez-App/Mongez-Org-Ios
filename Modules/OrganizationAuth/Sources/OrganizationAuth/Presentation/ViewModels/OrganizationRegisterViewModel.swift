import Foundation
import Combine
import SwiftUI
import PhotosUI
import MapKit

@MainActor
public class OrganizationRegisterViewModel: ObservableObject {
    @Published public var request = RegisterOrganizationRequest()
    
    // UI State
    @Published public var currentStep: Int = 1
    @Published public var totalSteps: Int = 5
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    @Published public var isRegistered = false
    
    // Step 1 extras
    @Published public var confirmPassword = ""
    @Published public var isPasswordVisible = false
    @Published public var isConfirmPasswordVisible = false
    
    // Step 2 extras - Logo
    @Published public var logoImage: UIImage? = nil
    @Published public var showImagePicker = false
    
    // Step 3 extras - Dynamic lists
    @Published public var targetAudienceItems: [String] = []
    @Published public var newTargetAudience = ""
    @Published public var servicesItems: [String] = []
    @Published public var newService = ""
    
    // Step 4 extras - Map
    @Published public var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357), // Cairo default
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published public var mapAnnotation = CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357)
    @Published public var documentURLs: [String] = []
    @Published public var newDocumentURL = ""
    
    // Industry options
    public let industryOptions = ["Technology", "Education", "Healthcare", "Finance", "E-Commerce", "Marketing", "Consulting", "Non-Profit", "Other"]
    
    private let useCase: OrganizationAuthUseCase
    
    public init(useCase: OrganizationAuthUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Target Audience
    public func addTargetAudience() {
        let trimmed = newTargetAudience.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        targetAudienceItems.append(trimmed)
        newTargetAudience = ""
    }
    
    public func removeTargetAudience(at index: Int) {
        guard targetAudienceItems.indices.contains(index) else { return }
        targetAudienceItems.remove(at: index)
    }
    
    // MARK: - Services
    public func addService() {
        let trimmed = newService.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        servicesItems.append(trimmed)
        newService = ""
    }
    
    public func removeService(at index: Int) {
        guard servicesItems.indices.contains(index) else { return }
        servicesItems.remove(at: index)
    }
    
    // MARK: - Documents
    public func addDocument() {
        let trimmed = newDocumentURL.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        documentURLs.append(trimmed)
        newDocumentURL = ""
    }
    
    public func removeDocument(at index: Int) {
        guard documentURLs.indices.contains(index) else { return }
        documentURLs.remove(at: index)
    }
    
    // MARK: - Navigation
    public func nextStep() {
        guard validateCurrentStep() else { return }
        
        if currentStep < 4 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep += 1
            }
        } else if currentStep == 4 {
            submitRegistration()
        }
    }
    
    public func previousStep() {
        if currentStep > 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
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
            if request.password.count < 6 {
                errorMessage = "Password must be at least 6 characters."
                return false
            }
            if request.password != confirmPassword {
                errorMessage = "Passwords do not match."
                return false
            }
        case 2:
            if request.industryField.isEmpty {
                errorMessage = "Industry Field is required."
                return false
            }
        case 3:
            if request.numberOfMembers.isEmpty {
                errorMessage = "Number of Members is required."
                return false
            }
        case 4:
            if request.contactEmail.isEmpty || request.phoneNumber.isEmpty || request.address.isEmpty {
                errorMessage = "Contact Email, Phone, and Address are required."
                return false
            }
        default:
            break
        }
        return true
    }
    
    private func submitRegistration() {
        // Sync dynamic lists to request
        request.servicesProvided = servicesItems
        request.targetAudience = targetAudienceItems.joined(separator: ", ")
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                _ = try await useCase.register(request: request)
                withAnimation(.easeInOut(duration: 0.3)) {
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
