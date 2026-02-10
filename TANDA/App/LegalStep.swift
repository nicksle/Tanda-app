import SwiftUI

// MARK: - LegalStep
// Step 3 of onboarding: Accept terms and privacy policy.

struct LegalStep: View {
    @Binding var agreedToTerms: Bool
    @Binding var agreedToPrivacy: Bool

    var isValid: Bool {
        agreedToTerms && agreedToPrivacy
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Terms & Privacy")
                .font(TANDATypography.Heading.l)
                .foregroundStyle(TANDAColors.Text.primary)
                .padding(.bottom, TANDASpacing.xs)

            Text("Please review and accept our terms to continue.")
                .font(TANDATypography.Paragraph.m)
                .foregroundStyle(TANDAColors.Text.secondary)
                .padding(.bottom, TANDASpacing.lg)

            Checkbox(
                isChecked: $agreedToTerms,
                label: "I agree to the Terms of Service",
                linkText: "Terms of Service"
            )

            Checkbox(
                isChecked: $agreedToPrivacy,
                label: "I have read and agree to the Privacy Policy",
                linkText: "Privacy Policy"
            )
        }
        .padding(.horizontal, TANDASpacing.lg)
    }
}

#Preview("Legal Step") {
    struct PreviewWrapper: View {
        @State private var terms = false
        @State private var privacy = false
        var body: some View {
            VStack {
                LegalStep(agreedToTerms: $terms, agreedToPrivacy: $privacy)
                Spacer()
            }
            .padding(.top, TANDASpacing.lg)
        }
    }
    return PreviewWrapper()
}
