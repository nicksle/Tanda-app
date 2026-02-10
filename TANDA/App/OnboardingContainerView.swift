import SwiftUI

// MARK: - OnboardingContainerView
// Container view managing 4-step onboarding flow.

struct OnboardingContainerView: View {
    @State private var currentStep = 1
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var agreedToTerms = false
    @State private var agreedToPrivacy = false
    @State private var hasPhoto = false
    @EnvironmentObject var appState: AppState

    private let totalSteps = 4

    var body: some View {
        SheetLayout(
            type: .immersive,
            title: "",
            showLeftAction: true,
            leftAction: { goBack() },
            showRightAction: false
        ) {
            VStack(spacing: 0) {
                ProgressBar(totalSteps: totalSteps, currentStep: currentStep)
                    .padding(.horizontal, TANDASpacing.lg)
                    .padding(.bottom, TANDASpacing.lg)

                stepContent

                Spacer()
            }
        } footer: {
            buttonDock
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 1:
            CreatePasswordStep(password: $password, confirmPassword: $confirmPassword)
        case 2:
            NameStep(firstName: $firstName, lastName: $lastName)
        case 3:
            LegalStep(agreedToTerms: $agreedToTerms, agreedToPrivacy: $agreedToPrivacy)
        case 4:
            PhotoStep(hasPhoto: $hasPhoto, firstName: firstName, lastName: lastName) {
                completeOnboarding()
            }
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private var buttonDock: some View {
        if currentStep == 4 {
            PrimaryButtonDock {
                PrimaryButton(
                    hasPhoto ? "Continue" : "Add Photo",
                    kind: .primary,
                    isFullWidth: true
                ) {
                    if hasPhoto {
                        completeOnboarding()
                    } else {
                        hasPhoto = true
                    }
                }
                PrimaryButton("Skip for Now", kind: .tertiary) {
                    completeOnboarding()
                }
            }
        } else {
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

    private var isCurrentStepValid: Bool {
        switch currentStep {
        case 1: return password.count >= 8 && password == confirmPassword
        case 2: return !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
                       !lastName.trimmingCharacters(in: .whitespaces).isEmpty
        case 3: return agreedToTerms && agreedToPrivacy
        case 4: return true
        default: return false
        }
    }

    private func goBack() {
        guard currentStep > 1 else { return }
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

    private func completeOnboarding() {
        appState.completeOnboarding()
    }
}

#Preview("Onboarding Container") {
    OnboardingContainerView()
        .environmentObject(AppState())
}
