import SwiftUI

// MARK: - LegalStep
// Step 3 of onboarding: Accept terms and privacy policy.

struct LegalStep: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                Text("Review Tanda Terms and Conditions")
                    .font(TANDATypography.Display.m)
                    .foregroundStyle(TANDAColors.Text.primary)

                Text("We want the Tanda Community to be a safe environment, we have created the following user agreement to protect the community members.")
                    .font(TANDATypography.Paragraph.l)
                    .foregroundStyle(TANDAColors.Text.secondary)
            }
            .padding(.horizontal, TANDASpacing.sm)
        }
        .padding(.horizontal, TANDASpacing.md)
    }
}

#Preview("Legal Step") {
    VStack {
        LegalStep()
        Spacer()
    }
    .padding(.top, TANDASpacing.lg)
}
