import SwiftUI
import UIKit
import Common

public struct SecureInputView: View {
    private let title: String
    private let placeholder: String
    @Binding private var text: String
    @Binding private var isVisible: Bool
    private let icon: String?

    public init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isVisible: Binding<Bool>,
        icon: String? = "lock"
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self._isVisible = isVisible
        self.icon = icon
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text(title)
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)

            HStack(spacing: AppTheme.Spacing.xxSmall) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.Colors.gray300)
                }

                Group {
                    if isVisible {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                }
                .font(AppTheme.textStyle(size: 15))

                Button {
                    isVisible.toggle()
                } label: {
                    Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.Colors.gray300)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .padding(.horizontal, AppTheme.Spacing.xSmall)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .stroke(AppTheme.Colors.gray200, lineWidth: 1)
            )
        }
    }
}

#Preview {
    SecureInputView(title: "Password", placeholder: "Enter your password", text: .constant(""), isVisible: .constant(false), icon: "lock")
        .padding()
}
