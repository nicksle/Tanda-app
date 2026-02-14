import SwiftUI

// MARK: - SheetIntro
// Left-aligned title + subtitle for sheet introductions.
// Used at the top of modals and sheets that introduce a task or flow.

struct SheetIntro: View {

    let title: String
    let subtitle: String?

    init(
        title: String,
        subtitle: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.xs) {
            Text(title)
                .font(TANDATypography.Heading.l)
                .foregroundStyle(TANDAColors.Text.primary)

            if let subtitle {
                Text(subtitle)
                    .font(TANDATypography.Paragraph.m)
                    .foregroundStyle(TANDAColors.Text.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Previews

#Preview("Title Only") {
    SheetIntro(title: "Create Account")
        .padding()
}

#Preview("With Subtitle") {
    SheetIntro(
        title: "Create Account",
        subtitle: "Enter your email to get started"
    )
    .padding()
}

#Preview("Longer Subtitle") {
    SheetIntro(
        title: "Add Payment Method",
        subtitle: "We'll use this to process payments and send money to your Circle members"
    )
    .padding()
}
