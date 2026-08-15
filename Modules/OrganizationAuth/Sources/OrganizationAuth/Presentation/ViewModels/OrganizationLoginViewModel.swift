import Foundation
import Combine

@MainActor
public class OrganizationLoginViewModel: ObservableObject {
    @Published public var email = ""
    @Published public var password = ""
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    @Published public var isAuthenticated = false
    
    private let useCase: OrganizationAuthUseCase
    
    public init(useCase: OrganizationAuthUseCase) {
        self.useCase = useCase
    }
    
    public func login() {
        guard validate() else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let request = LoginRequest(email: email, password: password)
                _ = try await useCase.login(request: request)
                self.isAuthenticated = true
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    private func validate() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please enter both email and password."
            return false
        }
        return true
    }
}
