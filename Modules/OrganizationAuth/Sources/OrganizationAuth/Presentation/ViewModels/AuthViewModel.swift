import Foundation
import Combine
import SwiftUI
import MapKit

@MainActor
public final class AuthViewModel: ObservableObject {

    @Published public var orgName = ""
    @Published public var email = ""
    @Published public var password = ""
    @Published public var confirmPassword = ""

    @Published public var industryField = ""
    @Published public var orgDescription = ""
    @Published public var targetAudience = ""
    @Published public var servicesProvided: [String] = []
    @Published public var newService = ""

    @Published public var contactEmail = ""
    @Published public var phone = ""
    @Published public var website = ""
    @Published public var address = ""
    @Published public var registrationNumber = ""
    @Published public var documentURL = ""
    @Published public var documentURLs: [String] = []

    @Published public var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published public var selectedCoordinate: CLLocationCoordinate2D?

    @Published public var isLoading = false
    @Published public var errorMessage: String?
    @Published public var currentStep = 1
    public let totalSteps = 5

    @Published public var isPasswordVisible = false
    @Published public var isConfirmPasswordVisible = false

    @Published public var isAuthenticated = false
    @Published public var authenticatedOrganization: Organization?

    public let industryOptions = [
        "Technology",
        "Education",
        "Healthcare",
        "Finance",
        "E-Commerce",
        "Marketing",
        "Consulting",
        "Non-Profit",
        "Other"
    ]

    private let useCase: AuthUseCase

    public init(useCase: AuthUseCase) {
        self.useCase = useCase
    }

    public func nextStep() {
        guard validateCurrentStep() else { return }
        guard currentStep < totalSteps else { return }

        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep += 1
        }
    }

    public func previousStep() {
        guard currentStep > 1 else { return }

        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep -= 1
        }
    }

    public func login() {
        guard validateLogin() else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let request = LoginRequest(email: self.email, password: self.password)
                let response = try await self.useCase.login(request: request)
                self.authenticatedOrganization = response.organization
                self.isAuthenticated = true
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }

    public func submitRegistration() {
        guard validateCurrentStep() else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await self.useCase.register(request: self.buildRegisterRequest())
                self.authenticatedOrganization = response.organization
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.currentStep = 4
                }
            } catch {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.currentStep = 4
                }
            }
            self.isLoading = false
        }
    }

    public func addDocument() {
        let trimmed = documentURL.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if !documentURLs.contains(trimmed) {
            documentURLs.append(trimmed)
        }
        documentURL = ""
    }

    public func removeDocument(at index: Int) {
        guard documentURLs.indices.contains(index) else { return }
        documentURLs.remove(at: index)
    }

    public func addService() {
        let trimmed = newService.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if !servicesProvided.contains(trimmed) {
            servicesProvided.append(trimmed)
        }
        newService = ""
    }

    public func removeService(at index: Int) {
        guard servicesProvided.indices.contains(index) else { return }
        servicesProvided.remove(at: index)
    }

    public func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: email)
    }

    public func validateCurrentStep() -> Bool {
        errorMessage = nil

        switch currentStep {
        case 1:
            guard !orgName.trimmingCharacters(in: .whitespaces).isEmpty else {
                errorMessage = "Organization name is required."
                return false
            }
            guard isValidEmail(email) else {
                errorMessage = "Please enter a valid email address."
                return false
            }
            guard password.count >= 6 else {
                errorMessage = "Password must be at least 6 characters."
                return false
            }
            guard password == confirmPassword else {
                errorMessage = "Passwords do not match."
                return false
            }
        case 2:
            guard !industryField.isEmpty else {
                errorMessage = "Industry field is required."
                return false
            }
        case 3:
            guard isValidEmail(contactEmail) else {
                errorMessage = "Please enter a valid contact email."
                return false
            }
            guard !phone.trimmingCharacters(in: .whitespaces).isEmpty else {
                errorMessage = "Phone number is required."
                return false
            }
            guard !address.trimmingCharacters(in: .whitespaces).isEmpty else {
                errorMessage = "Address is required."
                return false
            }
        default:
            break
        }

        return true
    }

    private func validateLogin() -> Bool {
        errorMessage = nil

        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return false
        }
        guard !password.isEmpty else {
            errorMessage = "Please enter your password."
            return false
        }
        return true
    }

    private func buildRegisterRequest() -> RegisterRequest {
        RegisterRequest(
            organizationName: orgName,
            email: email,
            password: password,
            industryField: industryField,
            description: orgDescription,
            targetAudience: targetAudience,
            servicesProvided: servicesProvided,
            contactEmail: contactEmail,
            phoneNumber: phone,
            websiteURL: website,
            address: address,
            registrationNumber: registrationNumber,
            documentURL: documentURLs.joined(separator: ", ")
        )
    }
}
