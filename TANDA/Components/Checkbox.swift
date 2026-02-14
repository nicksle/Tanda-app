import SwiftUI

// MARK: - Checkbox
// Toggleable checkbox for legal agreements.

struct Checkbox: View {
    @Binding var isChecked: Bool
    let label: String
    var linkText: String? = nil
    var onLinkTap: (() -> Void)? = nil

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                isChecked.toggle()
            }
        } label: {
            HStack(alignment: .top, spacing: TANDASpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isChecked ? TANDAColors.Brand.primary : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(
                                    isChecked ? TANDAColors.Brand.primary : TANDAColors.Neutral.n700,
                                    lineWidth: 2
                                )
                        )

                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 24, height: 24)

                labelView
            }
        }
        .buttonStyle(.plain)
        .padding(.vertical, TANDASpacing.sm)
    }

    @ViewBuilder
    private var labelView: some View {
        if let linkText = linkText, let linkRange = label.range(of: linkText) {
            let beforeLink = String(label[..<linkRange.lowerBound])
            let afterLink = String(label[linkRange.upperBound...])

            (Text(beforeLink).foregroundStyle(TANDAColors.Text.tertiary) +
             Text(linkText).foregroundStyle(TANDAColors.Brand.primary).underline() +
             Text(afterLink).foregroundStyle(TANDAColors.Text.tertiary))
                .font(TANDATypography.Paragraph.s)
                .multilineTextAlignment(.leading)
        } else {
            Text(label)
                .font(TANDATypography.Paragraph.s)
                .foregroundStyle(TANDAColors.Text.tertiary)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview("Checkbox") {
    struct PreviewWrapper: View {
        @State private var checked = false
        var body: some View {
            Checkbox(
                isChecked: $checked,
                label: "I agree to the Terms of Service",
                linkText: "Terms of Service"
            )
            .padding(24)
            .background(TANDAColors.Neutral.n900)
        }
    }
    return PreviewWrapper()
}
