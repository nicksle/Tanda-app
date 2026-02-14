import SwiftUI

// MARK: - SurveyStep1
// Step 1 of user segmentation: Primary goal question.

struct SurveyStep1: View {
    @Binding var selectedGoals: Set<String>

    private let options = [
        "Save for a specific goal",
        "Build an emergency fund",
        "Save with friends/family",
        "Manage group expenses",
        "Split costs fairly"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("What brings you to TANDA?")
                .font(TANDATypography.Display.m)
                .foregroundStyle(TANDAColors.Text.primary)
                .padding(.bottom, TANDASpacing.xs)

            Text("Help us personalize your experience")
                .font(TANDATypography.Paragraph.l)
                .foregroundStyle(TANDAColors.Text.secondary)
                .padding(.bottom, TANDASpacing.lg)

            VStack(spacing: TANDASpacing.sm) {
                ForEach(options, id: \.self) { option in
                    SelectionCard(
                        title: option,
                        isSelected: selectedGoals.contains(option)
                    ) {
                        toggleSelection(option)
                    }
                }
            }
        }
        .padding(.horizontal, TANDASpacing.lg)
    }

    private func toggleSelection(_ option: String) {
        if selectedGoals.contains(option) {
            selectedGoals.remove(option)
        } else {
            selectedGoals.insert(option)
        }
    }
}

#Preview("Survey Step 1") {
    struct PreviewWrapper: View {
        @State private var selectedGoals: Set<String> = []
        var body: some View {
            VStack {
                SurveyStep1(selectedGoals: $selectedGoals)
                Spacer()
            }
            .padding(.top, TANDASpacing.lg)
        }
    }
    return PreviewWrapper()
}
