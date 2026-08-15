import SwiftUI
import Common

public enum OrganizationAuthRoute: Hashable {
    case login
    case register
    case success
}

@MainActor
public class OrganizationAuthCoordinator: ObservableObject {
    @Published public var path: [OrganizationAuthRoute] = []
    
    private let useCase: OrganizationAuthUseCase
    
    public init(useCase: OrganizationAuthUseCase) {
        self.useCase = useCase
    }
    
    public func navigate(to route: OrganizationAuthRoute) {
        path.append(route)
    }
    
    public func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    public func popToRoot() {
        path.removeAll()
    }
    
    @ViewBuilder
    public func buildView(route: OrganizationAuthRoute) -> some View {
        switch route {
        case .login:
            let viewModel = OrganizationLoginViewModel(useCase: useCase)
            OrganizationLoginView(
                viewModel: viewModel,
                onNavigateToRegister: { [weak self] in
                    self?.navigate(to: .register)
                },
                onLoginSuccess: { [weak self] in
                    self?.navigate(to: .success)
                }
            )
        case .register:
            let viewModel = OrganizationRegisterViewModel(useCase: useCase)
            OrganizationRegisterWizardView(
                viewModel: viewModel,
                onRegistrationComplete: { [weak self] in
                    self?.navigate(to: .success)
                },
                onBackToLogin: { [weak self] in
                    self?.pop()
                }
            )
        case .success:
            OrganizationSuccessView(
                onDashboardTap: { [weak self] in
                    self?.popToRoot()
                    // Handle transition to dashboard (can notify parent coordinator or publish state)
                }
            )
        }
    }
}

// SwiftUI Container View that coordinates navigation using NavigationStack
public struct OrganizationAuthCoordinatorView: View {
    @StateObject private var coordinator: OrganizationAuthCoordinator
    
    public init(coordinator: OrganizationAuthCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.buildView(route: .login)
                .navigationDestination(for: OrganizationAuthRoute.self) { route in
                    coordinator.buildView(route: route)
                }
        }
    }
}
