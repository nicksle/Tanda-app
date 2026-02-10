import SwiftUI

// MARK: - NameStep
// Step 2 of onboarding: Enter first and last name.

struct NameStep: View {
    @Binding var firstName: String
    @Binding var lastName: String

    var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("What's Your Name?")
                .font(TANDATypography.Heading.l)
                .foregroundStyle(.white)
                .padding(.bottom, TANDASpacing.xs)

            Text("Let us know what to call you.")
                .font(TANDATypography.Paragraph.m)
                .foregroundStyle(TANDAColors.Text.secondary)
                .padding(.bottom, TANDASpacing.lg)

            Input(
                text: $firstName,
                label: "First Name",
                placeholder: "Enter your first name"
            )
            .padding(.bottom, TANDASpacing.md)

            Input(
                text: $lastName,
                label: "Last Name",
                placeholder: "Enter your last name"
            )
        }
        .padding(.horizontal, TANDASpacing.lg)
    }
}

#Preview("Name Step") {
    struct PreviewWrapper: View {
        @State private var firstName = ""
        @State private var lastName = ""
        var body: some View {
            VStack {
                NameStep(firstName: $firstName, lastName: $lastName)
                Spacer()
            }
            .padding(.top, TANDASpacing.lg)
            .background(TANDAColors.Neutral.n900)
        }
    }
    return PreviewWrapper()
}
