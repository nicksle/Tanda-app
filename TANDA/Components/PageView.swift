import SwiftUI

// MARK: - PageView
// Base page layout with fixed Head, scrollable Body, and translucent Footer overlay.
// Used as the foundation for most screens in TANDA.

struct PageView<Head: View, Body: View, Foot: View>: View {
    
    let footerHeight: CGFloat
    let footerMaterial: Material
    let showFooter: Bool
    let head: () -> Head
    let bodyContent: () -> Body
    let foot: () -> Foot
    
    init(
        footerHeight: CGFloat = 120,
        footerMaterial: Material = .ultraThinMaterial,
        showFooter: Bool = true,
        @ViewBuilder head: @escaping () -> Head,
        @ViewBuilder body: @escaping () -> Body,
        @ViewBuilder foot: @escaping () -> Foot
    ) {
        self.footerHeight = footerHeight
        self.footerMaterial = footerMaterial
        self.showFooter = showFooter
        self.head = head
        self.bodyContent = body
        self.foot = foot
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // HEAD — Fixed at top
                head()
                    .padding(.horizontal, TANDASpacing.lg)
                    .padding(.top, TANDASpacing.md)
                    .padding(.bottom, TANDASpacing.sm)
                
                // BODY — Scrollable
                ScrollView {
                    self.bodyContent()
                        .padding(.horizontal, TANDASpacing.md)
                        .padding(.bottom, showFooter ? footerHeight + TANDASpacing.md : TANDASpacing.md)
                }
            }
            
            // FOOTER — Translucent overlay
            if showFooter {
                VStack(spacing: 0) {
                    foot()
                        .padding(.horizontal, TANDASpacing.md)
                        .padding(.top, TANDASpacing.md)
                        .padding(.bottom, TANDASpacing.lg) // Safe area for home indicator (24px)
                }
                .frame(maxWidth: .infinity)
                .background(footerMaterial)
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

// MARK: - Convenience Init (No Footer)

extension PageView where Foot == EmptyView {
    init(
        @ViewBuilder head: @escaping () -> Head,
        @ViewBuilder body: @escaping () -> Body
    ) {
        self.init(
            showFooter: false,
            head: head,
            body: body,
            foot: { EmptyView() }
        )
    }
}

// MARK: - Preview

#Preview("PageView") {
    PageView(footerHeight: 140) {
        // HEAD
        VStack(alignment: .leading, spacing: TANDASpacing.xs) {
            Text("Welcome")
                .font(TANDATypography.Display.l)
            Text("Let's get you set up")
                .font(TANDATypography.Paragraph.m)
                .foregroundStyle(.secondary)
        }
    } body: {
        // BODY
        VStack(spacing: TANDASpacing.sm) {
            ForEach(1...10, id: \.self) { i in
                HStack(spacing: TANDASpacing.sm + 4) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(TANDAColors.Purple.p500.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text("\(i)")
                                .font(TANDATypography.Label.m)
                                .foregroundStyle(TANDAColors.Purple.p500)
                        )
                    VStack(alignment: .leading) {
                        Text("Item \(i)")
                            .font(TANDATypography.Heading.s)
                        Text("Description for item")
                            .font(TANDATypography.Paragraph.s)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(TANDASpacing.sm + 4)
                .background(TANDAColors.Neutral.n800.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
            }
        }
    } foot: {
        // FOOTER
        VStack(spacing: TANDASpacing.sm) {
            PrimaryButton("Continue", kind: .primary, isFullWidth: true) { }
            PrimaryButton("Skip for now", kind: .tertiary) { }
        }
    }
}
