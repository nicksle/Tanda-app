import SwiftUI

// MARK: - KYC Verification View
// Full-screen modal managing the 7-step KYC verification flow.
// Steps: Name → Address → SSN → DOB → Government ID → Selfie → Review & Submit

struct KYCVerificationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    @State private var currentStep = 0  // Start at intro screen
    @State private var isSubmitting = false
    @State private var showSuccessAlert = false

    // Step 1: Legal Name (auto-filled from user profile)
    @State private var firstName = ""
    @State private var lastName = ""

    // Step 2: Address
    @State private var streetAddress = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""

    // Step 3: SSN
    @State private var ssn = ""

    // Step 4: Date of Birth
    @State private var dateOfBirth = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()

    // Step 5: Government ID
    @State private var idType = ""
    @State private var frontImage: UIImage? = nil
    @State private var backImage: UIImage? = nil

    // Step 6: Selfie
    @State private var selfieImage: UIImage? = nil

    private let totalSteps = 7  // 7 form steps (not counting intro)

    var body: some View {
        SheetLayout(
            type: .immersive,
            title: "Verify Identity",
            showLeftAction: currentStep > 0,  // Show back from step 1 onwards
            leftAction: { goBack() },
            showRightAction: true,
            rightAction: { dismiss() }
        ) {
            VStack(spacing: 0) {
                // Progress bar (hide on intro screen)
                if currentStep > 0 {
                    ProgressBar(totalSteps: totalSteps, currentStep: currentStep)
                        .padding(.horizontal, TANDASpacing.lg)
                        .padding(.bottom, TANDASpacing.lg)
                }

                // Step content
                stepContent
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        )
                    )
                    .id(currentStep)
            }
        } footer: {
            buttonDock
        }
        .alert("Verification Submitted", isPresented: $showSuccessAlert) {
            Button("OK") {
                appState.completeKYCVerification()
                dismiss()
            }
        } message: {
            Text("Your identity verification has been submitted. We'll review your information and notify you within 1-2 business days.")
        }
        .onAppear {
            // Auto-fill name from user profile
            let nameComponents = appState.currentUser.name.split(separator: " ")
            if nameComponents.count >= 2 {
                firstName = String(nameComponents[0])
                lastName = nameComponents.dropFirst().joined(separator: " ")
            } else if let name = nameComponents.first {
                firstName = String(name)
            }
        }
    }

    // MARK: - Step Content

    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 0:
            KYCIntroScreen()
        case 1:
            KYCNameStep(
                firstName: $firstName,
                lastName: $lastName
            )
        case 2:
            AddressStep(
                streetAddress: $streetAddress,
                city: $city,
                state: $state,
                zipCode: $zipCode
            )
        case 3:
            SSNStep(ssn: $ssn)
        case 4:
            DateOfBirthStep(dateOfBirth: $dateOfBirth)
        case 5:
            GovernmentIDStep(
                idType: $idType,
                frontImage: $frontImage,
                backImage: $backImage
            )
        case 6:
            SelfieVerificationStep(selfieImage: $selfieImage)
        case 7:
            ReviewSubmitStep(
                firstName: firstName,
                lastName: lastName,
                ssn: ssn,
                dateOfBirth: dateOfBirth,
                streetAddress: streetAddress,
                city: city,
                state: state,
                zipCode: zipCode,
                idType: idType,
                frontImage: frontImage,
                backImage: backImage,
                selfieImage: selfieImage
            )
        default:
            EmptyView()
        }
    }

    // MARK: - Button Dock

    @ViewBuilder
    private var buttonDock: some View {
        if currentStep == 0 {
            // Intro screen: Get Started button
            PrimaryButtonDock {
                PrimaryButton(
                    "Get Started",
                    kind: .primary,
                    isFullWidth: true
                ) {
                    goToNextStep()
                }
            }
        } else if currentStep == totalSteps {
            // Final step: Submit button
            PrimaryButtonDock {
                PrimaryButton(
                    "Submit for Verification",
                    kind: .primary,
                    isLoading: isSubmitting,
                    isDisabled: !isCurrentStepValid,
                    isFullWidth: true
                ) {
                    submitVerification()
                }
            }
        } else {
            // Other steps: Continue button
            PrimaryButtonDock {
                PrimaryButton(
                    "Continue",
                    kind: .primary,
                    isDisabled: !isCurrentStepValid,
                    isFullWidth: true
                ) {
                    goToNextStep()
                }
            }
        }
    }

    // MARK: - Validation

    private var isCurrentStepValid: Bool {
        switch currentStep {
        case 0:
            // Intro screen: Always valid
            return true

        case 1:
            // Name: First and last name filled
            return !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
                   !lastName.trimmingCharacters(in: .whitespaces).isEmpty

        case 2:
            // Address: All address fields filled
            return !streetAddress.trimmingCharacters(in: .whitespaces).isEmpty &&
                   !city.trimmingCharacters(in: .whitespaces).isEmpty &&
                   !state.isEmpty &&
                   zipCode.count == 5 &&
                   zipCode.allSatisfy { $0.isNumber }

        case 3:
            // SSN: 9 digits required
            let ssnDigitsOnly = ssn.filter { $0.isNumber }
            return ssnDigitsOnly.count == 9

        case 4:
            // Date of Birth: Always valid (date picker always has value)
            return true

        case 5:
            // Government ID: ID type selected, front image uploaded, back image if not passport
            if idType.isEmpty || frontImage == nil {
                return false
            }
            // If not passport, require back image
            if idType != "Passport" && backImage == nil {
                return false
            }
            return true

        case 6:
            // Selfie: Image uploaded
            return selfieImage != nil

        case 7:
            // Review: Always valid (just reviewing)
            return true

        default:
            return false
        }
    }

    // MARK: - Navigation

    private func goBack() {
        guard currentStep > 0 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep -= 1
        }
    }

    private func goToNextStep() {
        guard currentStep < totalSteps else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep += 1
        }
    }

    private func submitVerification() {
        isSubmitting = true

        // Simulate submission delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            showSuccessAlert = true
        }
    }
}

// MARK: - KYC Intro Screen

struct KYCIntroScreen: View {
    var body: some View {
        ScrollView {
            VStack(spacing: TANDASpacing.xl) {
                Spacer()
                    .frame(height: TANDASpacing.lg)

                // Icon
                ZStack {
                    SwiftUI.Circle()
                        .fill(
                            LinearGradient(
                                colors: [TANDAColors.Purple.p500, TANDAColors.Purple.p400],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 96, height: 96)

                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.white)
                }

                // Title and description
                VStack(spacing: TANDASpacing.sm) {
                    Text("Verify Your Identity")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(TANDAColors.Text.primary)

                    Text("To keep your account secure and comply with financial regulations, we need to verify your identity.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(TANDAColors.Text.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, TANDASpacing.lg)

                // What you'll need
                VStack(alignment: .leading, spacing: TANDASpacing.md) {
                    Text("What you'll need")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(TANDAColors.Text.primary)

                    VStack(spacing: TANDASpacing.sm) {
                        RequirementRow(
                            icon: "number",
                            title: "Social Security Number",
                            description: "Your 9-digit SSN"
                        )

                        RequirementRow(
                            icon: "calendar",
                            title: "Date of Birth",
                            description: "To verify your age"
                        )

                        RequirementRow(
                            icon: "house",
                            title: "Address",
                            description: "Your current residential address"
                        )

                        RequirementRow(
                            icon: "creditcard",
                            title: "Government ID",
                            description: "Driver's license, passport, or state ID"
                        )

                        RequirementRow(
                            icon: "person.crop.square",
                            title: "Selfie",
                            description: "A quick photo for identity verification"
                        )
                    }
                }
                .padding(TANDASpacing.lg)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(TANDAColors.Neutral.n50)
                .clipShape(RoundedRectangle(cornerRadius: TANDARadius.xl))
                .padding(.horizontal, TANDASpacing.lg)

                // Time estimate
                HStack(spacing: TANDASpacing.sm) {
                    Image(systemName: "clock")
                        .font(.system(size: 16))
                        .foregroundStyle(TANDAColors.Purple.p500)

                    Text("Takes about 3-5 minutes")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(TANDAColors.Text.secondary)
                }

                Spacer()
            }
        }
    }
}

// MARK: - Requirement Row

private struct RequirementRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: TANDASpacing.sm) {
            ZStack {
                SwiftUI.Circle()
                    .fill(TANDAColors.Purple.p100)
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(TANDAColors.Purple.p500)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(TANDAColors.Text.primary)

                Text(description)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(TANDAColors.Text.secondary)
            }

            Spacer()
        }
    }
}

#Preview("KYC Intro") {
    KYCIntroScreen()
}

#Preview("KYC Verification") {
    KYCVerificationView()
        .environmentObject(AppState())
}
