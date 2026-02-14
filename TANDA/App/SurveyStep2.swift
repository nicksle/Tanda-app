import SwiftUI

// MARK: - SurveyStep2
// Step 2 of user segmentation: Savings experience question.

struct SurveyStep2: View {
    @Binding var selectedExperience: Set<String>

    private let options = [
        "New to saving",
        "Save occasionally",
        "Regular saver",
        "Experienced with saving groups"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("How do you save today?")
                .font(TANDATypography.Display.m)
                .foregroundStyle(TANDAColors.Text.primary)
                .padding(.bottom, TANDASpacing.xs)

            Text("Tell us about your saving habits")
                .font(TANDATypography.Paragraph.l)
                .foregroundStyle(TANDAColors.Text.secondary)
                .padding(.bottom, TANDASpacing.lg)

            VStack(spacing: TANDASpacing.sm) {
                ForEach(options, id: \.self) { option in
                    SelectionCard(
                        title: option,
                        isSelected: selectedExperience.contains(option)
                    ) {
                        toggleSelection(option)
                    }
                }
            }
        }
        .padding(.horizontal, TANDASpacing.lg)
    }

    private func toggleSelection(_ option: String) {
        if selectedExperience.contains(option) {
            selectedExperience.remove(option)
        } else {
            selectedExperience.insert(option)
        }
    }
}

#Preview("Survey Step 2") {
    struct PreviewWrapper: View {
        @State private var selectedExperience: Set<String> = []
        var body: some View {
            VStack {
                SurveyStep2(selectedExperience: $selectedExperience)
                Spacer()
            }
            .padding(.top, TANDASpacing.lg)
        }
    }
    return PreviewWrapper()
}
