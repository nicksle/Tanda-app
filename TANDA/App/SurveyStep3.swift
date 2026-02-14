import SwiftUI

// MARK: - SurveyStep3
// Step 3 of user segmentation: Group size preference question.

struct SurveyStep3: View {
    @Binding var selectedGroupSizes: Set<String>

    private let options = [
        "Just me (solo)",
        "Close friends (2-5 people)",
        "Extended group (6-10 people)",
        "Large community (11+ people)"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Who will you save with?")
                .font(TANDATypography.Display.m)
                .foregroundStyle(TANDAColors.Text.primary)
                .padding(.bottom, TANDASpacing.xs)

            Text("Select all that apply")
                .font(TANDATypography.Paragraph.l)
                .foregroundStyle(TANDAColors.Text.secondary)
                .padding(.bottom, TANDASpacing.lg)

            VStack(spacing: TANDASpacing.sm) {
                ForEach(options, id: \.self) { option in
                    SelectionCard(
                        title: option,
                        isSelected: selectedGroupSizes.contains(option)
                    ) {
                        toggleSelection(option)
                    }
                }
            }
        }
        .padding(.horizontal, TANDASpacing.lg)
    }

    private func toggleSelection(_ option: String) {
        if selectedGroupSizes.contains(option) {
            selectedGroupSizes.remove(option)
        } else {
            selectedGroupSizes.insert(option)
        }
    }
}

#Preview("Survey Step 3") {
    struct PreviewWrapper: View {
        @State private var selectedGroupSizes: Set<String> = []
        var body: some View {
            VStack {
                SurveyStep3(selectedGroupSizes: $selectedGroupSizes)
                Spacer()
            }
            .padding(.top, TANDASpacing.lg)
        }
    }
    return PreviewWrapper()
}
