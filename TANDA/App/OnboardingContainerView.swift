import SwiftUI

// MARK: - OnboardingContainerView
// Container view managing 4-step onboarding flow.

struct OnboardingContainerView: View {
    @State private var currentStep = 1
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var preferredName = ""
    @State private var agreedToLegal = false
    @State private var hasPhoto = false
    @State private var showSurvey = false
    @EnvironmentObject var appState: AppState

    private let totalSteps = 4

    var body: some View {
        SheetLayout(
            type: .immersive,
            title: "Create Account",
            showLeftAction: true,
            leftAction: { goBack() },
            showRightAction: false
        ) {
            VStack(spacing: 0) {
                ProgressBar(totalSteps: totalSteps, currentStep: currentStep)
                    .padding(.horizontal, TANDASpacing.lg)
                    .padding(.bottom, TANDASpacing.lg)

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
        .sheet(isPresented: $showSurvey) {
            UserSegmentationSurveyView(
                firstName: !preferredName.isEmpty ? preferredName : firstName,
                hasPhoto: hasPhoto,
                onComplete: {
                    // Dismiss survey - loading screen already underneath
                    showSurvey = false
                }
            )
            .environmentObject(appState)
            .presentationDetents([PresentationDetent.large])
            .interactiveDismissDisabled()
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 1:
            CreatePasswordStep(password: $password, confirmPassword: $confirmPassword)
        case 2:
            NameStep(firstName: $firstName, lastName: $lastName, preferredName: $preferredName)
        case 3:
            LegalStep()
        case 4:
            PhotoStep(hasPhoto: $hasPhoto, firstName: firstName, lastName: lastName, onComplete: {})
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private var buttonDock: some View {
        if currentStep == 3 {
            PrimaryButtonDock {
                Checkbox(
                    isChecked: $agreedToLegal,
                    label: "By checking this box, you ceritfy that you're 18 years old or older, and you agree to the User Agreement and Policy Service and Privacy Policy.",
                    linkText: nil
                )
            } buttons: {
                PrimaryButton(
                    "Continue",
                    kind: .primary,
                    isDisabled: !isCurrentStepValid,
                    isFullWidth: true
                ) {
                    goToNextStep()
                }
            }
        } else if currentStep == 4 {
            PrimaryButtonDock {
                PrimaryButton(
                    hasPhoto ? "Continue" : "Add Photo",
                    kind: .primary,
                    isFullWidth: true
                ) {
                    if hasPhoto {
                        showSurveyView()
                    } else {
                        hasPhoto = true
                    }
                }
                PrimaryButton("Skip for Now", kind: .tertiary) {
                    showSurveyView()
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
        case 3: return agreedToLegal
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

    private func showSurveyView() {
        // Transition onboarding to loading screen immediately
        completeOnboarding()

        // Small delay, then show survey over the loading screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showSurvey = true
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
