import SwiftUI
import Common

public struct OrganizationDetailsView: View {
    @ObservedObject var viewModel: AuthViewModel

    public init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                    StepProgressIndicator(
                        currentStep: viewModel.currentStep,
                        totalSteps: viewModel.totalSteps
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.small)

                    Text("Organization Details")
                        .font(AppTheme.textStyle(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)

                    industryField

                    descriptionField

                    targetAudienceField

                    servicesField

                    if let error = viewModel.errorMessage {
                        errorBanner(error)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.large)
                .padding(.bottom, AppTheme.Spacing.large)
            }

            bottomButtons
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var industryField: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text("Industry Field")
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)

            Menu {
                ForEach(viewModel.industryOptions, id: \.self) { option in
                    Button(option) {
                        viewModel.industryField = option
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.industryField.isEmpty ? "Select industry" : viewModel.industryField)
                        .font(AppTheme.textStyle(size: 15))
                        .foregroundColor(viewModel.industryField.isEmpty ? AppTheme.Colors.gray300 : AppTheme.Colors.black100)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.Colors.gray300)
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

    private var descriptionField: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text("Description (Optional)")
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)

            TextEditor(text: $viewModel.orgDescription)
                .font(AppTheme.textStyle(size: 15))
                .frame(height: 90)
                .padding(AppTheme.Spacing.xSmall)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                )
        }
    }

    private var targetAudienceField: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text("Target Audience (Optional)")
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)

            CustomTextField(
                title: "",
                placeholder: "e.g. CS Graduates",
                text: $viewModel.targetAudience,
                keyboardType: .default,
                autocapitalization: .sentences
            )
        }
    }

    private var servicesField: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text("Services Provided (Optional)")
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)

            ForEach(Array(viewModel.servicesProvided.enumerated()), id: \.offset) { index, service in
                HStack {
                    Text(service)
                        .font(AppTheme.textStyle(size: 15))
                        .foregroundColor(AppTheme.Colors.black100)

                    Spacer()

                    Button {
                        viewModel.removeService(at: index)
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.Colors.gray300)
                    }
                }
                .frame(height: 48)
                .padding(.horizontal, AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                )
            }

            HStack {
                TextField("e.g. Online Courses", text: $viewModel.newService)
                    .font(AppTheme.textStyle(size: 15))
                    .frame(height: 48)
                    .padding(.horizontal, AppTheme.Spacing.xSmall)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                    )

                Button {
                    viewModel.addService()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple200)
                        .frame(width: 48, height: 48)
                        .background(
                            Circle().fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.1))
                        )
                }
            }
        }
    }

    private var bottomButtons: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Button {
                viewModel.previousStep()
            } label: {
                Text("Back")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.1))
                    .foregroundColor(AppTheme.Colors.purple200)
                    .cornerRadius(AppTheme.radius.meduim)
            }

            Button {
                viewModel.nextStep()
            } label: {
                Text("Next")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppTheme.Colors.purple200)
                    .foregroundColor(AppTheme.Colors.white100)
                    .cornerRadius(AppTheme.radius.meduim)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.large)
    }

    private func errorBanner(_ message: String) -> some View {
        HStack(spacing: AppTheme.Spacing.xxSmall) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(AppTheme.Colors.red100)

            Text(message)
                .font(AppTheme.textStyle(size: 13))
                .foregroundColor(AppTheme.Colors.red100)
        }
        .padding(AppTheme.Spacing.xSmall)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .fill(AppTheme.Colors.red100.opacity(0.1))
        )
    }
}

#Preview {
    OrganizationDetailsView(viewModel: AuthViewModel(useCase: AuthUseCaseImpl(repository: OrganizationAuthRepositoryImpl(networkService: OrganizationAuthNetworkServiceImpl()))))
}
