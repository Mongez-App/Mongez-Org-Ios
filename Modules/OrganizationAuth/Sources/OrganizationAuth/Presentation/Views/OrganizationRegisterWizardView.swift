import SwiftUI
import Common
import MapKit

// MARK: - Main Wizard Container
public struct OrganizationRegisterWizardView: View {
    @StateObject private var viewModel: OrganizationRegisterViewModel
    public var onRegistrationComplete: () -> Void
    public var onBackToLogin: () -> Void
    
    public init(viewModel: OrganizationRegisterViewModel, onRegistrationComplete: @escaping () -> Void, onBackToLogin: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onRegistrationComplete = onRegistrationComplete
        self.onBackToLogin = onBackToLogin
    }
    
    public var body: some View {
        ZStack {
            AppTheme.Colors.white100.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Step Indicator
                StepIndicatorView(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)
                    .padding(.top, AppTheme.Spacing.medium)
                    .padding(.horizontal, AppTheme.Spacing.large)
                
                // Content
                if viewModel.currentStep == 5 {
                    OrganizationSuccessView(onDashboardTap: onRegistrationComplete)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                            // Error banner
                            if let error = viewModel.errorMessage {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(AppTheme.Colors.red100)
                                    Text(error)
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
                            
                            switch viewModel.currentStep {
                            case 1: Step1AccountView(viewModel: viewModel)
                            case 2: Step2BasicInfoView(viewModel: viewModel)
                            case 3: Step3ServicesView(viewModel: viewModel)
                            case 4: Step4ContactView(viewModel: viewModel)
                            default: EmptyView()
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.large)
                        .padding(.top, AppTheme.Spacing.medium)
                        .padding(.bottom, 100)
                    }
                    
                    // Bottom Buttons
                    bottomButtons
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(image: $viewModel.logoImage)
        }
    }
    
    private var bottomButtons: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            // Back button
            Button(action: {
                if viewModel.currentStep == 1 {
                    onBackToLogin()
                } else {
                    viewModel.previousStep()
                }
            }) {
                Text("Back")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppTheme.Colors.purple200)
                    .foregroundColor(AppTheme.Colors.white100)
                    .cornerRadius(AppTheme.radius.meduim)
            }
            
            // Next / Submit button
            Button(action: {
                viewModel.nextStep()
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.white100))
                    } else {
                        Text(viewModel.currentStep == 4 ? "Submit" : "Next")
                            .font(AppTheme.textStyle(size: 16, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(AppTheme.Colors.purple200)
                .foregroundColor(AppTheme.Colors.white100)
                .cornerRadius(AppTheme.radius.meduim)
            }
            .disabled(viewModel.isLoading)
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.large)
    }
}

// MARK: - Step Indicator
struct StepIndicatorView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...totalSteps, id: \.self) { step in
                // Circle
                ZStack {
                    Circle()
                        .fill(step <= currentStep ? AppTheme.Colors.purple200 : Color.clear)
                        .frame(width: 32, height: 32)
                    
                    Circle()
                        .stroke(step <= currentStep ? AppTheme.Colors.purple200 : AppTheme.Colors.gray300, lineWidth: 1.5)
                        .frame(width: 32, height: 32)
                    
                    Text("\(step)")
                        .font(AppTheme.textStyle(size: 14, weight: .bold))
                        .foregroundColor(step <= currentStep ? AppTheme.Colors.white100 : AppTheme.Colors.gray300)
                }
                
                // Connector line
                if step < totalSteps {
                    Rectangle()
                        .fill(step < currentStep ? AppTheme.Colors.purple200 : AppTheme.Colors.gray300)
                        .frame(height: 1.5)
                }
            }
        }
    }
}

// MARK: - Reusable Field Components
struct OrgFieldBlock: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var autocap: TextInputAutocapitalization = .sentences
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(autocap)
                .disableAutocorrection(true)
                .font(AppTheme.textStyle(size: 15))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .padding(.horizontal, AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.2), lineWidth: 1)
                )
        }
    }
}

struct OrgSecureFieldBlock: View {
    let title: String
    @Binding var text: String
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
            
            HStack {
                Image("password")
                    .foregroundColor(AppTheme.Colors.gray300)
                
                Group {
                    if isVisible {
                        TextField("••••••••", text: $text)
                    } else {
                        SecureField("••••••••", text: $text)
                    }
                }
                .font(AppTheme.textStyle(size: 15))
                
                Button {
                    isVisible.toggle()
                } label: {
                    Image(isVisible ? "eye_shown" : "eye_hidden")
                        .foregroundColor(AppTheme.Colors.gray300)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .padding(.horizontal, AppTheme.Spacing.xSmall)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.2), lineWidth: 1)
            )
        }
    }
}

// MARK: - Step 1: Account Credentials
struct Step1AccountView: View {
    @ObservedObject var viewModel: OrganizationRegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("Account Credentials")
                .font(AppTheme.textStyle(size: 24, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
            
            // Email
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(AppTheme.textStyle(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                HStack {
                    Image("email")
                        .foregroundColor(AppTheme.Colors.gray300)
                    TextField("JohnDoe@gmail.com", text: $viewModel.request.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(AppTheme.textStyle(size: 15))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .padding(.horizontal, AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.2), lineWidth: 1)
                )
            }
            
            // Organization Name
            OrgFieldBlock(title: "Organization Name", placeholder: "Enter organization name", text: $viewModel.request.organizationName)
            
            // Password
            OrgSecureFieldBlock(title: "Password", text: $viewModel.request.password, isVisible: $viewModel.isPasswordVisible)
            
            // Confirm Password
            OrgSecureFieldBlock(title: "Confirm Password", text: $viewModel.confirmPassword, isVisible: $viewModel.isConfirmPasswordVisible)
        }
    }
}

// MARK: - Step 2: Basic Info
struct Step2BasicInfoView: View {
    @ObservedObject var viewModel: OrganizationRegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("Basic Info")
                .font(AppTheme.textStyle(size: 24, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
            
            // Logo
            VStack {
                Button(action: {
                    viewModel.showImagePicker = true
                }) {
                    if let img = viewModel.logoImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(AppTheme.Colors.gray200, lineWidth: 1))
                    } else {
                        ZStack {
                            Circle()
                                .fill(AppTheme.Colors.gray100)
                                .frame(width: 100, height: 100)
                            Image(systemName: "camera.fill")
                                .foregroundColor(AppTheme.Colors.gray300)
                                .font(.system(size: 28))
                        }
                    }
                }
                Text("Add Logo")
                    .font(AppTheme.textStyle(size: 13))
                    .foregroundColor(AppTheme.Colors.gray300)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.small)
            
            // Industry Field - Dropdown
            VStack(alignment: .leading, spacing: 8) {
                Text("Industry Field")
                    .font(AppTheme.textStyle(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                Menu {
                    ForEach(viewModel.industryOptions, id: \.self) { option in
                        Button(option) {
                            viewModel.request.industryField = option
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.request.industryField.isEmpty ? "Select industry" : viewModel.request.industryField)
                            .font(AppTheme.textStyle(size: 15))
                            .foregroundColor(viewModel.request.industryField.isEmpty ? AppTheme.Colors.gray300 : AppTheme.Colors.black100)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(AppTheme.Colors.gray300)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .padding(.horizontal, AppTheme.Spacing.xSmall)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.2), lineWidth: 1)
                    )
                }
            }
            
            // Description
            VStack(alignment: .leading, spacing: 8) {
                Text("Description (Optional)")
                    .font(AppTheme.textStyle(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                TextEditor(text: $viewModel.request.description)
                    .font(AppTheme.textStyle(size: 15))
                    .frame(height: 80)
                    .padding(AppTheme.Spacing.xxxSmall)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.2), lineWidth: 1)
                    )
            }
        }
    }
}

// MARK: - Step 3: Services & Audience
struct Step3ServicesView: View {
    @ObservedObject var viewModel: OrganizationRegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("Services & Audience")
                .font(AppTheme.textStyle(size: 24, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
            
            // Target Audience
            VStack(alignment: .leading, spacing: 8) {
                Text("Target Audience")
                    .font(AppTheme.textStyle(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                ForEach(Array(viewModel.targetAudienceItems.enumerated()), id: \.offset) { index, item in
                    HStack {
                        Text(item)
                            .font(AppTheme.textStyle(size: 15))
                            .foregroundColor(AppTheme.Colors.black100)
                        Spacer()
                        Button { viewModel.removeTargetAudience(at: index) } label: {
                            Image(systemName: "trash")
                                .foregroundColor(AppTheme.Colors.gray300)
                        }
                    }
                    .frame(height: 48)
                    .padding(.horizontal, AppTheme.Spacing.xSmall)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.2), lineWidth: 1)
                    )
                }
                
                // New audience input
                HStack {
                    TextField("e.g. CS Graduates", text: $viewModel.newTargetAudience)
                        .font(AppTheme.textStyle(size: 15))
                    
                    if !viewModel.newTargetAudience.isEmpty {
                        Button {
                            viewModel.addTargetAudience()
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppTheme.Colors.purple200)
                        }
                    }
                }
                .frame(height: 48)
                .padding(.horizontal, AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.2), lineWidth: 1)
                )
                
                // Add button
                Button(action: { viewModel.addTargetAudience() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple200)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
            }
            
            // Services Provided
            VStack(alignment: .leading, spacing: 8) {
                Text("Services Provided")
                    .font(AppTheme.textStyle(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                ForEach(Array(viewModel.servicesItems.enumerated()), id: \.offset) { index, item in
                    HStack {
                        Text(item)
                            .font(AppTheme.textStyle(size: 15))
                            .foregroundColor(AppTheme.Colors.black100)
                        Spacer()
                        Button { viewModel.removeService(at: index) } label: {
                            Image(systemName: "trash")
                                .foregroundColor(AppTheme.Colors.gray300)
                        }
                    }
                    .frame(height: 48)
                    .padding(.horizontal, AppTheme.Spacing.xSmall)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.2), lineWidth: 1)
                    )
                }
                
                HStack {
                    TextField("e.g. Learning", text: $viewModel.newService)
                        .font(AppTheme.textStyle(size: 15))
                    
                    if !viewModel.newService.isEmpty {
                        Button {
                            viewModel.addService()
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppTheme.Colors.purple200)
                        }
                    }
                }
                .frame(height: 48)
                .padding(.horizontal, AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.2), lineWidth: 1)
                )
                
                Button(action: { viewModel.addService() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple200)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
            }
            
            // Number of Members
            OrgFieldBlock(title: "Number of Members", placeholder: "e.g. 10", text: $viewModel.request.numberOfMembers, keyboard: .numberPad)
        }
    }
}

// MARK: - Step 4: Contact & Location
struct Step4ContactView: View {
    @ObservedObject var viewModel: OrganizationRegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("Contact & Location")
                .font(AppTheme.textStyle(size: 24, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
            
            OrgFieldBlock(title: "Contact Email", placeholder: "route@test.com", text: $viewModel.request.contactEmail, keyboard: .emailAddress, autocap: .never)
            
            OrgFieldBlock(title: "Phone Number", placeholder: "010", text: $viewModel.request.phoneNumber, keyboard: .phonePad)
            
            OrgFieldBlock(title: "Website URL (Optional)", placeholder: "Enter website URL", text: $viewModel.request.websiteURL, keyboard: .URL, autocap: .never)
            
            OrgFieldBlock(title: "Address", placeholder: "Enter full address", text: $viewModel.request.address)
            
            // Map
            Map(coordinateRegion: $viewModel.mapRegion, annotationItems: [MapPin(coordinate: viewModel.mapAnnotation)]) { pin in
                MapMarker(coordinate: pin.coordinate, tint: .red)
            }
            .frame(height: 180)
            .cornerRadius(AppTheme.radius.small)
            
            OrgFieldBlock(title: "Registration Number (Optional)", placeholder: "Enter registration number", text: $viewModel.request.registrationNumber)
            
            // Documents
            VStack(alignment: .leading, spacing: 8) {
                Text("Documents (Optional)")
                    .font(AppTheme.textStyle(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                ForEach(Array(viewModel.documentURLs.enumerated()), id: \.offset) { index, url in
                    HStack {
                        Text(url)
                            .font(AppTheme.textStyle(size: 14))
                            .foregroundColor(AppTheme.Colors.black100)
                            .lineLimit(1)
                        Spacer()
                        Button { viewModel.removeDocument(at: index) } label: {
                            Image(systemName: "trash")
                                .foregroundColor(AppTheme.Colors.gray300)
                        }
                    }
                    .frame(height: 48)
                    .padding(.horizontal, AppTheme.Spacing.xSmall)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.2), lineWidth: 1)
                    )
                }
                
                TextField("Document URL", text: $viewModel.newDocumentURL)
                    .font(AppTheme.textStyle(size: 15))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .padding(.horizontal, AppTheme.Spacing.xSmall)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.2), lineWidth: 1)
                    )
                
                Button(action: { viewModel.addDocument() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple200)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
            }
        }
    }
}

// MARK: - Map Pin Model
struct MapPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.image = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.image = originalImage
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
