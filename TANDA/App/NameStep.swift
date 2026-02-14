import SwiftUI

// MARK: - NameStep
// Step 2 of onboarding: Enter first name, last name, and optional preferred name.

struct NameStep: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var preferredName: String

    var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                Text("Hello! What's your name?")
                    .font(TANDATypography.Display.m)
                    .foregroundStyle(TANDAColors.Text.primary)

                Text("Input your full legal name and let us know if you'd be preferred to be called something else.")
                    .font(TANDATypography.Paragraph.l)
                    .foregroundStyle(TANDAColors.Text.secondary)
            }
            .padding(.bottom, TANDASpacing.lg)
            .padding(.horizontal, TANDASpacing.sm)

            Input(
                text: $firstName,
                label: "Legal First Name",
                placeholder: "Enter your first name"
            )
            .padding(.bottom, TANDASpacing.md)
            .padding(.horizontal, TANDASpacing.sm)

            Input(
                text: $lastName,
                label: "Legal Last Name",
                placeholder: "Enter your last name"
            )
            .padding(.bottom, TANDASpacing.md)
            .padding(.horizontal, TANDASpacing.sm)

            Input(
                text: $preferredName,
                label: "Preferred Name (Optional)",
                placeholder: "What would you like to be called?"
            )
            .padding(.horizontal, TANDASpacing.sm)
        }
        .padding(.horizontal, TANDASpacing.md)
    }
}

#Preview("Name Step") {
    struct PreviewWrapper: View {
        @State private var firstName = ""
        @State private var lastName = ""
        @State private var preferredName = ""
        var body: some View {
            VStack {
                NameStep(firstName: $firstName, lastName: $lastName, preferredName: $preferredName)
                Spacer()
            }
            .padding(.top, TANDASpacing.lg)
        }
    }
    return PreviewWrapper()
}
