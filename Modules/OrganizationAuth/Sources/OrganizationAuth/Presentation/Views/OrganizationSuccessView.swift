import SwiftUI
import Common

public struct OrganizationSuccessView: View {
    public var onDashboardTap: () -> Void
    
    public init(onDashboardTap: @escaping () -> Void) {
        self.onDashboardTap = onDashboardTap
    }
    
    public var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Spacer()
            
            // Illustration placeholder
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(AppTheme.Colors.purple100)
            
            Text("Verified!")
                .font(AppTheme.textStyle(size: 28, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
            
            Text("Congratulations! Your request has been reviewed and accepted.")
                .font(AppTheme.textStyle(size: 16))
                .foregroundColor(AppTheme.Colors.gray300)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.xLarge)
            
            Spacer()
            
            Button(action: onDashboardTap) {
                Text("Go to Dashboard")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.Colors.purple100)
                    .foregroundColor(AppTheme.Colors.white100)
                    .cornerRadius(AppTheme.radius.small)
            }
            .padding(.bottom, AppTheme.Spacing.large)
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .navigationBarHidden(true)
    }
}
