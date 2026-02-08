import SwiftUI

// MARK: - TANDAButtonDock
// Footer container for action buttons.
// Supports 1–4 stacked buttons with an optional accessory view.
// Used in sheets and page footers.

struct TANDAButtonDock<Accessory: View>: View {
    
    let buttons: [AnyView]
    let accessory: Accessory?
    let useMaterial: Bool
    
    // MARK: - Init with Accessory
    
    init(
        useMaterial: Bool = false,
        @ViewBuilder accessory: () -> Accessory,
        @TANDAButtonDockBuilder buttons: () -> [AnyView]
    ) {
        self.useMaterial = useMaterial
        self.accessory = accessory()
        self.buttons = buttons()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: TANDASpacing.sm) {
                // Accessory
                if let accessory {
                    accessory
                }
                
                // Buttons
                ForEach(Array(buttons.enumerated()), id: \.offset) { _, button in
                    button
                }
            }
            .padding(.horizontal, TANDASpacing.md)
            .padding(.top, TANDASpacing.md)
            .padding(.bottom, 34) // Safe area for home indicator
        }
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if useMaterial {
                    AnyView(Rectangle().fill(.ultraThinMaterial))
                } else {
                    AnyView(Color.clear)
                }
            }
        )
    }
}

// MARK: - Init without Accessory

extension TANDAButtonDock where Accessory == EmptyView {
    init(
        useMaterial: Bool = false,
        @TANDAButtonDockBuilder buttons: () -> [AnyView]
    ) {
        self.useMaterial = useMaterial
        self.accessory = nil
        self.buttons = buttons()
    }
}

// MARK: - Result Builder

@resultBuilder
struct TANDAButtonDockBuilder {
    static func buildBlock(_ components: any View...) -> [AnyView] {
        components.map { AnyView($0) }
    }
}

// MARK: - Previews

#Preview("1 Button") {
    VStack {
        Spacer()
        TANDAButtonDock {
            TANDAButton("Continue", kind: .primary, isFullWidth: true) { }
        }
    }
}

#Preview("2 Buttons") {
    VStack {
        Spacer()
        TANDAButtonDock {
            TANDAButton("Confirm Payment", kind: .primary, isFullWidth: true) { }
            TANDAButton("Cancel", kind: .tertiary) { }
        }
    }
}

#Preview("3 Buttons") {
    VStack {
        Spacer()
        TANDAButtonDock {
            TANDAButton("Edit Amount", kind: .secondary, size: .large, isFullWidth: true) { }
            TANDAButton("Send $50.00", kind: .primary, isFullWidth: true) { }
            TANDAButton("Cancel", kind: .tertiary) { }
        }
    }
}

#Preview("With Accessory") {
    VStack {
        Spacer()
        TANDAButtonDock {
            HStack(spacing: TANDASpacing.sm + 4) {
                Image(systemName: "checkmark.square.fill")
                    .foregroundStyle(TANDAColors.Brand.primary)
                Text("I agree to the terms and conditions")
                    .font(TANDATypography.Paragraph.s)
            }
            .padding(TANDASpacing.sm + 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(TANDAColors.Neutral.n50)
            .clipShape(RoundedRectangle(cornerRadius: TANDARadius.sm))
        } buttons: {
            TANDAButton("Create Circle", kind: .primary, isFullWidth: true) { }
            TANDAButton("Cancel", kind: .tertiary) { }
        }
    }
}
