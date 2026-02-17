import SwiftUI

// MARK: - Input
// Form input component supporting text, amount, password, and search types.
// Includes label, placeholder, helper text, error state, and prefix.

struct Input: View {
    
    // MARK: - Types
    
    enum InputType {
        case text
        case amount
        case password
        case search
        case ssn
    }

    enum InputStyle {
        case bordered
        case underlined
        case search
    }

    // MARK: - Properties

    @Binding var text: String
    let type: InputType
    let style: InputStyle
    let label: String?
    let placeholder: String
    let helperText: String?
    let error: String?
    let prefix: String?
    let isDisabled: Bool
    
    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible: Bool = false
    
    // MARK: - Init
    
    init(
        text: Binding<String>,
        type: InputType = .text,
        style: InputStyle = .underlined,
        label: String? = nil,
        placeholder: String = "",
        helperText: String? = nil,
        error: String? = nil,
        prefix: String? = nil,
        isDisabled: Bool = false
    ) {
        self._text = text
        self.type = type
        // Auto-determine style based on type if not explicitly set
        if type == .search {
            self.style = .search
        } else {
            self.style = style
        }
        self.label = label
        self.placeholder = placeholder
        self.helperText = helperText
        self.error = error
        self.prefix = (type == .amount && prefix == nil) ? "$" : prefix
        self.isDisabled = isDisabled
    }
    
    // MARK: - Computed
    
    private var hasError: Bool { error != nil }
    
    private var borderColor: Color {
        if hasError { return TANDAColors.Feedback.red }
        if isFocused { return TANDAColors.Neutral.n900 }
        return TANDAColors.Neutral.n500
    }
    
    private var borderWidth: CGFloat {
        (isFocused || hasError) ? 2 : 1
    }
    
    private var labelColor: Color {
        if hasError { return TANDAColors.Feedback.red }
        if isFocused { return TANDAColors.Neutral.n900 }
        return TANDAColors.Neutral.n400
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: style == .underlined ? TANDASpacing.xs : TANDASpacing.xs + 2) {
            // Label
            if let label, style != .search {
                Text(label)
                    .font(TANDATypography.Label.s)
                    .foregroundStyle(labelColor)
            }

            // Input field based on style
            switch style {
            case .search:
                searchField
            case .bordered:
                standardField
            case .underlined:
                underlinedField
            }

            // Helper / Error text
            if let error {
                Text(error)
                    .font(TANDATypography.Paragraph.s)
                    .foregroundStyle(TANDAColors.Feedback.red)
            } else if let helperText {
                Text(helperText)
                    .font(TANDATypography.Paragraph.s)
                    .foregroundStyle(TANDAColors.Text.secondary)
            }
        }
        .opacity(isDisabled ? 0.5 : 1.0)
        .disabled(isDisabled)
    }
    
    // MARK: - Standard Field
    
    private var standardField: some View {
        HStack(spacing: TANDASpacing.xs) {
            // Prefix
            if let prefix {
                Text(prefix)
                    .font(TANDATypography.Paragraph.l)
                    .foregroundStyle(TANDAColors.Text.secondary)
            }
            
            // Text field
            if type == .password && !isPasswordVisible {
                SecureField(placeholder, text: $text)
                    .font(TANDATypography.Paragraph.l)
                    .focused($isFocused)
            } else {
                TextField(placeholder, text: $text)
                    .font(TANDATypography.Paragraph.l)
                    .focused($isFocused)
                    .keyboardType(keyboardType)
            }
            
            // Password toggle
            if type == .password {
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Text(isPasswordVisible ? "Hide" : "Show")
                        .font(TANDATypography.Label.s)
                        .foregroundStyle(TANDAColors.Brand.primary)
                }
            }
        }
        .padding(.horizontal, TANDASpacing.md)
        .frame(height: 56)
        .background(TANDAColors.Neutral.n800.opacity(0.001)) // Tap target
        .overlay(
            RoundedRectangle(cornerRadius: TANDARadius.md)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
    }
    
    // MARK: - Search Field
    
    private var searchField: some View {
        HStack(spacing: TANDASpacing.sm + 4) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(TANDAColors.Text.secondary)
                .font(.system(size: 18))
            
            TextField(placeholder, text: $text)
                .font(TANDATypography.Paragraph.m)
                .focused($isFocused)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(TANDAColors.Text.tertiary)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, TANDASpacing.md)
        .frame(height: 48)
        .background(TANDAColors.Neutral.n100)
        .clipShape(Capsule())
    }

    // MARK: - Underlined Field

    private var underlinedField: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: TANDASpacing.xs) {
                // Prefix
                if let prefix {
                    Text(prefix)
                        .font(TANDATypography.Heading.l)
                        .foregroundStyle(TANDAColors.Text.secondary)
                }

                // Text field
                if type == .password && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .font(TANDATypography.Heading.l)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .font(TANDATypography.Heading.l)
                        .focused($isFocused)
                        .keyboardType(keyboardType)
                }

                // Password toggle
                if type == .password {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Text(isPasswordVisible ? "Hide" : "Show")
                            .font(TANDATypography.Label.s)
                            .foregroundStyle(TANDAColors.Brand.primary)
                    }
                }
            }
            .padding(.vertical, TANDASpacing.sm)

            // Bottom divider
            Rectangle()
                .fill(borderColor)
                .frame(height: borderWidth)
                .padding(.bottom, TANDASpacing.md)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
                .animation(.easeInOut(duration: 0.2), value: hasError)
        }
    }

    // MARK: - Keyboard Type
    
    private var keyboardType: UIKeyboardType {
        switch type {
        case .text: return .default
        case .amount: return .decimalPad
        case .password: return .default
        case .search: return .default
        case .ssn: return .numberPad
        }
    }
}

// MARK: - Preview

#Preview("Input Variants") {
    ScrollView {
        VStack(spacing: 32) {
            Input(
                text: .constant("Sarah Johnson"),
                label: "Full Name",
                placeholder: "Enter your name"
            )
            
            Input(
                text: .constant(""),
                label: "Email",
                placeholder: "name@example.com"
            )
            
            Input(
                text: .constant("500.00"),
                type: .amount,
                label: "Contribution",
                helperText: "Minimum $50 per cycle"
            )
            
            Input(
                text: .constant(""),
                type: .password,
                label: "Password",
                placeholder: "Enter password"
            )
            
            Input(
                text: .constant(""),
                type: .search,
                placeholder: "Search members..."
            )
            
            Input(
                text: .constant("invalidemail"),
                label: "Email",
                error: "Please enter a valid email address"
            )
            
            Input(
                text: .constant(""),
                label: "Disabled",
                placeholder: "Can't edit this",
                isDisabled: true
            )
        }
        .padding(24)
    }
    .background(Color.white)
}
