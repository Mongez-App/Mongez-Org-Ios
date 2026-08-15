import SwiftUI
import UIKit
import Common

public struct CustomTextField: View {
    private let title: String
    private let placeholder: String
    @Binding private var text: String
    private let icon: String?
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    private let autocapitalization: TextInputAutocapitalization
    private let autocorrectionDisabled: Bool

    public init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        icon: String? = nil,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization = .sentences,
        autocorrectionDisabled: Bool = true
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocapitalization = autocapitalization
        self.autocorrectionDisabled = autocorrectionDisabled
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text(title)
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)

            HStack(spacing: AppTheme.Spacing.xxSmall) {
                if let icon {
                    fieldIcon(icon)
                }

                TextField(placeholder, text: $text)
                    .font(AppTheme.textStyle(size: 15))
                    .keyboardType(keyboardType)
                    .textContentType(textContentType)
                    .textInputAutocapitalization(autocapitalization)
                    .disableAutocorrection(autocorrectionDisabled)
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

    @ViewBuilder
    private func fieldIcon(_ icon: String) -> some View {
        if let uiImage = UIImage(named: icon, in: .module, compatibleWith: nil) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        } else {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.Colors.gray300)
        }
    }
}

#Preview {
    CustomTextField(title: "Email", placeholder: "Enter your email", text: .constant(""), icon: "envelope")
        .padding()
}
