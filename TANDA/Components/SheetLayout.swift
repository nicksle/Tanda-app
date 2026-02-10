import SwiftUI

// MARK: - SheetType

enum SheetType {
    case half      // Modal sheet with medium height (.presentationDetents([.medium]))
    case full      // Modal sheet with full height (.presentationDetents([.large]))
    case immersive // Full screen cover (edge-to-edge)
}

// MARK: - SheetLayout

// Reusable layout component for sheet content with optional header, scrollable body, and fixed footer overlay.
// Provides consistent structure across all sheets in TANDA.

struct SheetLayout<Header: View, Body: View, Footer: View>: View {

    let type: SheetType
    let showHeader: Bool
    let showFooter: Bool
    let header: () -> Header
    let bodyContent: () -> Body
    let footer: () -> Footer

    init(
        type: SheetType = .half,
        showHeader: Bool = true,
        showFooter: Bool = true,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder body: @escaping () -> Body,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.type = type
        self.showHeader = showHeader
        self.showFooter = showFooter
        self.header = header
        self.bodyContent = body
        self.footer = footer
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // HEADER - Fixed at top
                if showHeader {
                    header()
                }

                // BODY - Scrollable
                ScrollView {
                    bodyContent()
                        .padding(.bottom, showFooter ? 140 : TANDASpacing.md)
                }
            }

            // FOOTER - Fixed overlay at bottom
            if showFooter {
                footer()
            }
        }
    }
}

// MARK: - Convenience Initializers

extension SheetLayout where Header == EmptyView {
    init(
        type: SheetType = .half,
        showFooter: Bool = true,
        @ViewBuilder body: @escaping () -> Body,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.init(
            type: type,
            showHeader: false,
            showFooter: showFooter,
            header: { EmptyView() },
            body: body,
            footer: footer
        )
    }
}

extension SheetLayout where Footer == EmptyView {
    init(
        type: SheetType = .half,
        showHeader: Bool = true,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder body: @escaping () -> Body
    ) {
        self.init(
            type: type,
            showHeader: showHeader,
            showFooter: false,
            header: header,
            body: body,
            footer: { EmptyView() }
        )
    }
}

extension SheetLayout where Header == EmptyView, Footer == EmptyView {
    init(
        type: SheetType = .half,
        @ViewBuilder body: @escaping () -> Body
    ) {
        self.init(
            type: type,
            showHeader: false,
            showFooter: false,
            header: { EmptyView() },
            body: body,
            footer: { EmptyView() }
        )
    }
}

// MARK: - SheetHeader Convenience Initializer

extension SheetLayout where Header == SheetHeader {
    init(
        type: SheetType = .half,
        title: String,
        subtitle: String? = nil,
        showLeftAction: Bool = false,
        leftAction: (() -> Void)? = nil,
        leftIcon: Image = Image(systemName: "chevron.left"),
        showRightAction: Bool = false,
        rightAction: (() -> Void)? = nil,
        rightIcon: Image = Image(systemName: "xmark"),
        showDivider: Bool = false,
        showFooter: Bool = true,
        @ViewBuilder body: @escaping () -> Body,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.init(
            type: type,
            showHeader: true,
            showFooter: showFooter,
            header: {
                SheetHeader(
                    title: title,
                    subtitle: subtitle,
                    leftAction: showLeftAction ? leftAction : nil,
                    leftIcon: leftIcon,
                    rightAction: showRightAction ? rightAction : nil,
                    rightIcon: rightIcon,
                    showDivider: showDivider
                )
            },
            body: body,
            footer: footer
        )
    }
}

// MARK: - Previews

#Preview("With Header and Footer") {
    Color.black.ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            SheetLayout(type: .half) {
                VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                    Text("Create Account")
                        .font(TANDATypography.Heading.l)
                    Text("Enter your details to get started")
                        .font(TANDATypography.Paragraph.m)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, TANDASpacing.md)
                .padding(.top, TANDASpacing.md)
            } body: {
                VStack(spacing: TANDASpacing.md) {
                    ForEach(1...10, id: \.self) { i in
                        HStack {
                            Text("Form Field \(i)")
                                .font(TANDATypography.Paragraph.m)
                            Spacer()
                        }
                        .padding(TANDASpacing.md)
                        .background(TANDAColors.Neutral.n100)
                        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
                    }
                }
                .padding(.horizontal, TANDASpacing.md)
            } footer: {
                PrimaryButtonDock {
                    PrimaryButton("Continue", kind: .primary, isFullWidth: true) { }
                }
            }
            .presentationDetents([.medium])
        }
}

#Preview("Header Only") {
    Color.black.ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            SheetLayout(type: .half) {
                SheetHeader(
                    title: "Details",
                    rightAction: { }
                )
            } body: {
                VStack(spacing: TANDASpacing.sm) {
                    Text("Content goes here")
                        .font(TANDATypography.Paragraph.m)
                        .padding()
                }
            } footer: {
                EmptyView()
            }
            .presentationDetents([.medium])
        }
}

#Preview("Body Only") {
    Color.black.ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            SheetLayout(type: .full) {
                VStack(spacing: TANDASpacing.lg) {
                    Text("Full Screen Content")
                        .font(TANDATypography.Heading.l)
                    Text("This sheet has no header or footer")
                        .font(TANDATypography.Paragraph.m)
                        .foregroundStyle(.secondary)
                }
                .padding(TANDASpacing.lg)
            }
            .presentationDetents([.large])
        }
}
