import SwiftUI
import Common

public enum OrganizationAuthRoute: Hashable {
    case login
    case register
}

@MainActor
public class OrganizationAuthCoordinator: ObservableObject {
    @Published public var path: [OrganizationAuthRoute] = []
    @Published public var isAuthenticated = false

    private let useCase: AuthUseCase

    public init(useCase: AuthUseCase) {
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
            let viewModel = AuthViewModel(useCase: useCase)
            LoginView(
                viewModel: viewModel,
                onNavigateToRegister: { [weak self] in
                    self?.navigate(to: .register)
                },
                onLoginSuccess: { [weak self] in
                    self?.completeAuthentication()
                }
            )
        case .register:
            let viewModel = AuthViewModel(useCase: useCase)
            RegistrationWizardView(
                viewModel: viewModel,
                onBackToLogin: { [weak self] in
                    self?.pop()
                },
                onRegistrationComplete: { [weak self] in
                    self?.completeAuthentication()
                }
            )
        }
    }

    private func completeAuthentication() {
        isAuthenticated = true
        popToRoot()
    }
}

public struct OrganizationAuthCoordinatorView: View {
    @StateObject private var coordinator: OrganizationAuthCoordinator
    private let dashboardContent: () -> AnyView

    public init(
        coordinator: OrganizationAuthCoordinator,
        dashboardContent: @escaping () -> AnyView
    ) {
        _coordinator = StateObject(wrappedValue: coordinator)
        self.dashboardContent = dashboardContent
    }

    public var body: some View {
        if coordinator.isAuthenticated {
            dashboardContent()
        } else {
            NavigationStack(path: $coordinator.path) {
                coordinator.buildView(route: .login)
                    .navigationDestination(for: OrganizationAuthRoute.self) { route in
                        coordinator.buildView(route: route)
                    }
            }
        }
    }
}
