import SwiftUI

// MARK: - PrimaryButton
// Primary action component. Supports 4 kinds × 5 sizes.
// Constraint: Primary kind is Large only.

struct PrimaryButton: View {
    
    // MARK: - Types
    
    enum Kind {
        case primary
        case secondary
        case tertiary
        case destructive
    }
    
    enum Size {
        case large       // 56px height
        case medium      // 48px height
        case small       // 36px height
        case circleLarge // 48×48px
        case circleSmall // 36×36px
        
        var height: CGFloat {
            switch self {
            case .large: return 56
            case .medium, .circleLarge: return 48
            case .small, .circleSmall: return 36
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .large: return 24
            case .medium: return 20
            case .small: return 16
            case .circleLarge, .circleSmall: return 0
            }
        }
        
        var font: Font {
            switch self {
            case .large: return TANDATypography.Label.l
            case .medium: return TANDATypography.Label.m
            case .small: return TANDATypography.Label.s
            case .circleLarge, .circleSmall: return TANDATypography.Label.m
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .large, .medium, .circleLarge: return 20
            case .small, .circleSmall: return 16
            }
        }
        
        var isCircle: Bool {
            self == .circleLarge || self == .circleSmall
        }
    }
    
    // MARK: - Properties
    
    let label: String?
    let icon: Image?
    let kind: Kind
    let size: Size
    let leadingIcon: Image?
    let trailingIcon: Image?
    let isLoading: Bool
    let isDisabled: Bool
    let isFullWidth: Bool
    let accessibilityLabel: String?
    let action: () -> Void
    
    // MARK: - Init — Text Button
    
    init(
        _ label: String,
        kind: Kind = .primary,
        size: Size = .large,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        // Enforce: Primary is Large only
        assert(kind != .primary || size == .large, "Primary buttons must be Large size")
        
        self.label = label
        self.icon = nil
        self.kind = kind
        self.size = (kind == .primary) ? .large : size
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.isFullWidth = isFullWidth
        self.accessibilityLabel = nil
        self.action = action
    }
    
    // MARK: - Init — Circle / Icon Button
    
    init(
        icon: Image,
        kind: Kind = .secondary,
        size: Size = .circleLarge,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) {
        assert(kind != .primary, "Circle buttons cannot be Primary kind")
        
        self.label = nil
        self.icon = icon
        self.kind = kind
        self.size = size.isCircle ? size : .circleLarge
        self.leadingIcon = nil
        self.trailingIcon = nil
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.isFullWidth = false
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }
    
    // MARK: - Color Mapping
    
    private var fillColor: Color {
        switch kind {
        case .primary:     return TANDAColors.Purple.p500
        case .secondary:   return TANDAColors.Neutral.n100
        case .tertiary:    return .clear
        case .destructive: return TANDAColors.Feedback.red
        }
    }
    
    private var pressedFillColor: Color {
        switch kind {
        case .primary:     return TANDAColors.Purple.p600
        case .secondary:   return TANDAColors.Neutral.n200
        case .tertiary:    return TANDAColors.Neutral.n100
        case .destructive: return Color(hex: "#DC2626") // red/600
        }
    }
    
    private var textColor: Color {
        switch kind {
        case .primary:     return TANDAColors.Neutral.n0
        case .secondary:   return TANDAColors.Neutral.n900
        case .tertiary:    return TANDAColors.Neutral.n900
        case .destructive: return TANDAColors.Neutral.n0
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            guard !isDisabled && !isLoading else { return }
            action()
        }) {
            Group {
                if size.isCircle {
                    circleContent
                } else {
                    textContent
                }
            }
        }
        .buttonStyle(PrimaryButtonStyle(
            fillColor: fillColor,
            pressedFillColor: pressedFillColor,
            height: size.height,
            isCircle: size.isCircle,
            isFullWidth: isFullWidth
        ))
        .opacity(isDisabled ? 0.5 : 1.0)
        .disabled(isDisabled || isLoading)
        .accessibilityLabel(accessibilityLabel ?? label ?? "Button")
    }
    
    // MARK: - Content Views
    
    @ViewBuilder
    private var textContent: some View {
        HStack(spacing: TANDASpacing.sm) {
            if isLoading {
                SpinningLoader(
                    size: 20,
                    foregroundColor: textColor,
                    backgroundColor: textColor.opacity(0.2)
                )
            } else {
                if let leadingIcon {
                    leadingIcon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.iconSize, height: size.iconSize)
                }

                if let label {
                    Text(label)
                        .font(size.font)
                }

                if let trailingIcon {
                    trailingIcon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.iconSize, height: size.iconSize)
                }
            }
        }
        .foregroundStyle(textColor)
        .padding(.horizontal, size.horizontalPadding)
        .frame(height: size.height)
        .frame(maxWidth: isFullWidth ? .infinity : nil)
    }
    
    @ViewBuilder
    private var circleContent: some View {
        Group {
            if isLoading {
                SpinningLoader(
                    size: 18,
                    foregroundColor: textColor,
                    backgroundColor: textColor.opacity(0.2)
                )
            } else if let icon {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.iconSize, height: size.iconSize)
            }
        }
        .foregroundStyle(textColor)
        .frame(width: size.height, height: size.height)
    }
}

// MARK: - Button Style

struct PrimaryButtonStyle: ButtonStyle {
    let fillColor: Color
    let pressedFillColor: Color
    let height: CGFloat
    let isCircle: Bool
    let isFullWidth: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? pressedFillColor : fillColor)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview("Button Variants") {
    ScrollView {
        VStack(spacing: 24) {
            // Primary
            PrimaryButton("Continue", kind: .primary) { }
            PrimaryButton("Continue", kind: .primary, isFullWidth: true) { }
            
            // Secondary sizes
            PrimaryButton("Cancel", kind: .secondary, size: .large) { }
            PrimaryButton("Cancel", kind: .secondary, size: .medium) { }
            PrimaryButton("Cancel", kind: .secondary, size: .small) { }
            
            // Tertiary
            PrimaryButton("Skip", kind: .tertiary) { }
            
            // Destructive
            PrimaryButton("Delete", kind: .destructive) { }
            
            // States
            PrimaryButton("Disabled", kind: .primary, isDisabled: true) { }
            PrimaryButton("Loading", kind: .primary, isLoading: true) { }
            
            // With icons
            PrimaryButton(
                "Add Member",
                kind: .primary,
                leadingIcon: Image(systemName: "plus")
            ) { }
            
            // Circle
            PrimaryButton(
                icon: Image(systemName: "heart.fill"),
                kind: .secondary,
                size: .circleLarge,
                accessibilityLabel: "Favorite"
            ) { }
        }
        .padding(24)
    }
    .background(Color(hex: "#FFFFFF"))
}
