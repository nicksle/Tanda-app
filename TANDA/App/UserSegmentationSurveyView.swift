import SwiftUI

// MARK: - UserSegmentationSurveyView
// Container view managing 3-step user segmentation survey.
// Skippable multi-step survey to understand user goals and preferences.

struct UserSegmentationSurveyView: View {
    @State private var currentStep = 1
    @State private var selectedGoals: Set<String> = []
    @State private var selectedExperience: Set<String> = []
    @State private var selectedGroupSizes: Set<String> = []
    @EnvironmentObject var appState: AppState

    let firstName: String
    let hasPhoto: Bool
    private let totalSteps = 4

    var onComplete: () -> Void

    var body: some View {
        SheetLayout(
            type: .immersive,
            title: "Tell Us About You",
            showLeftAction: currentStep > 1,
            leftAction: { goBack() },
            showRightAction: false
        ) {
            VStack(spacing: 0) {
                // Show progress bar only for survey steps (2-4), not intro
                if currentStep > 1 {
                    ProgressBar(totalSteps: totalSteps - 1, currentStep: currentStep - 1)
                        .padding(.horizontal, TANDASpacing.lg)
                        .padding(.bottom, TANDASpacing.lg)
                }

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
    }

    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 1:
            SurveyIntro(firstName: firstName, hasPhoto: hasPhoto)
        case 2:
            SurveyStep1(selectedGoals: $selectedGoals)
        case 3:
            SurveyStep2(selectedExperience: $selectedExperience)
        case 4:
            SurveyStep3(selectedGroupSizes: $selectedGroupSizes)
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private var buttonDock: some View {
        PrimaryButtonDock {
            PrimaryButton(
                currentStep == 1 ? "Get Started" : (currentStep == totalSteps ? "Finish" : "Continue"),
                kind: .primary,
                isFullWidth: true
            ) {
                if currentStep == totalSteps {
                    completeSurvey()
                } else {
                    goToNextStep()
                }
            }
            PrimaryButton("Skip", kind: .tertiary) {
                skipSurvey()
            }
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

    private func completeSurvey() {
        // Store survey responses in AppState
        appState.surveyResponses = [
            "goals": Array(selectedGoals),
            "experience": Array(selectedExperience),
            "groupSizes": Array(selectedGroupSizes)
        ]
        onComplete()
    }

    private func skipSurvey() {
        // Mark as skipped but don't store responses
        appState.surveySkipped = true
        onComplete()
    }
}

#Preview("User Segmentation Survey") {
    UserSegmentationSurveyView(firstName: "Sarah", hasPhoto: true, onComplete: {})
        .environmentObject(AppState())
}
