import SwiftUI

// MARK: - SheetHeader
// Standardized header for sheet content.
// Supports title, optional subtitle, and left/right action buttons.

struct SheetHeader: View {
    
    let title: String
    let subtitle: String?
    let leftAction: (() -> Void)?
    let leftIcon: Image
    let rightAction: (() -> Void)?
    let rightIcon: Image
    let showDivider: Bool
    
    init(
        title: String,
        subtitle: String? = nil,
        leftAction: (() -> Void)? = nil,
        leftIcon: Image = Image(systemName: "chevron.left"),
        rightAction: (() -> Void)? = nil,
        rightIcon: Image = Image(systemName: "xmark"),
        showDivider: Bool = false
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leftAction = leftAction
        self.leftIcon = leftIcon
        self.rightAction = rightAction
        self.rightIcon = rightIcon
        self.showDivider = showDivider
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: TANDASpacing.sm) {
                // Left action
                if let leftAction {
                    headerButton(icon: leftIcon, action: leftAction)
                } else if rightAction != nil {
                    // Invisible spacer to keep title centered
                    Color.clear.frame(width: 32, height: 32)
                }
                
                Spacer()
                
                // Title group
                VStack(spacing: TANDASpacing.xxs) {
                    Text(title)
                        .font(TANDATypography.Heading.s)
                        .foregroundStyle(TANDAColors.Neutral.n900)
                    
                    if let subtitle {
                        Text(subtitle)
                            .font(TANDATypography.Paragraph.s)
                            .foregroundStyle(TANDAColors.Neutral.n500)
                    }
                }
                
                Spacer()
                
                // Right action
                if let rightAction {
                    headerButton(icon: rightIcon, action: rightAction)
                } else if leftAction != nil {
                    Color.clear.frame(width: 32, height: 32)
                }
            }
            .padding(.horizontal, TANDASpacing.md)
            .padding(.vertical, TANDASpacing.lg)
            
            if showDivider {
                Rectangle()
                    .fill(TANDAColors.Neutral.n200)
                    .frame(height: 1)
            }
        }
    }
    
    // MARK: - Header Button (Tertiary / Small)
    
    @ViewBuilder
    private func headerButton(icon: Image, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            icon
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(TANDAColors.Neutral.n900)
                .frame(width: 32, height: 32)
                .background(TANDAColors.Neutral.n100)
                .clipShape(Circle())
        }
    }
}

// MARK: - Previews

#Preview("Title Only") {
    SheetHeader(title: "Confirm Payment")
}

#Preview("With Close") {
    SheetHeader(
        title: "Transaction Details",
        rightAction: { }
    )
}

#Preview("Full Navigation") {
    SheetHeader(
        title: "Add Member",
        subtitle: "Step 2 of 3",
        leftAction: { },
        rightAction: { }
    )
}
