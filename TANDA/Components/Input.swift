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
    }

    enum InputStyle {
        case bordered    // Current default - rectangular border
        case underlined  // New minimal style - bottom divider only
    }

    enum InputSize {
        case standard  // Default size
        case large     // Larger variant for emphasis

        var height: CGFloat {
            switch self {
            case .standard: return 56
            case .large: return 72
            }
        }

        var font: Font {
            switch self {
            case .standard: return TANDATypography.Paragraph.l
            case .large: return TANDATypography.Heading.m
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .standard: return TANDARadius.md
            case .large: return TANDARadius.lg
            }
        }
    }

    // MARK: - Properties

    @Binding var text: String
    let type: InputType
    let size: InputSize
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
        size: InputSize = .standard,
        style: InputStyle = .bordered,
        label: String? = nil,
        placeholder: String = "",
        helperText: String? = nil,
        error: String? = nil,
        prefix: String? = nil,
        isDisabled: Bool = false
    ) {
        self._text = text
        self.type = type
        self.size = size
        self.style = style
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
        if isFocused { return TANDAColors.Brand.primary }
        return TANDAColors.Neutral.n300
    }

    private var borderWidth: CGFloat {
        (isFocused || hasError) ? 2 : 1
    }

    private var labelColor: Color {
        if hasError { return TANDAColors.Feedback.red }
        if isFocused { return TANDAColors.Brand.primary }
        return TANDAColors.Neutral.n400
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.xs + 2) {
            if style == .bordered {
                // Label (for bordered style only - underlined handles its own)
                if let label, type != .search {
                    Text(label)
                        .font(TANDATypography.Label.s)
                        .foregroundStyle(labelColor)
                }
            }

            // Input field
            switch (type, style) {
            case (.search, _):
                searchField
            case (_, .bordered):
                standardField
            case (_, .underlined):
                underlinedField
            }

            // Helper / Error text (for bordered style only)
            if style == .bordered {
                if let error {
                    Text(error)
                        .font(TANDATypography.Paragraph.s)
                        .foregroundStyle(TANDAColors.Feedback.red)
                } else if let helperText {
                    Text(helperText)
                        .font(TANDATypography.Paragraph.s)
                        .foregroundStyle(TANDAColors.Neutral.n500)
                }
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
                    .font(size.font)
                    .foregroundStyle(TANDAColors.Neutral.n500)
            }

            // Text field
            if type == .password && !isPasswordVisible {
                SecureField(placeholder, text: $text)
                    .font(size.font)
                    .focused($isFocused)
            } else {
                TextField(placeholder, text: $text)
                    .font(size.font)
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
        .frame(height: size.height)
        .background(TANDAColors.Neutral.n800.opacity(0.001)) // Tap target
        .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
    }

    // MARK: - Search Field

    private var searchField: some View {
        HStack(spacing: TANDASpacing.sm + 4) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(TANDAColors.Neutral.n500)
                .font(.system(size: 18))

            TextField(placeholder, text: $text)
                .font(TANDATypography.Paragraph.m)
                .focused($isFocused)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(TANDAColors.Neutral.n400)
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
            // Label
            if let label {
                Text(label)
                    .font(TANDATypography.Label.s)
                    .foregroundStyle(TANDAColors.Neutral.n400)
                    .padding(.bottom, TANDASpacing.xs)
            }

            // Text field with large font
            HStack(spacing: TANDASpacing.xs) {
                // Prefix
                if let prefix {
                    Text(prefix)
                        .font(TANDATypography.Display.m)
                        .foregroundStyle(TANDAColors.Neutral.n500)
                }

                if type == .password && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .font(TANDATypography.Display.m)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .font(TANDATypography.Display.m)
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

            // Divider
            Rectangle()
                .fill(TANDAColors.Neutral.n200)
                .frame(height: 1)
                .padding(.top, TANDASpacing.sm)

            // Subtitle (state-based: error or helperText)
            if let error {
                subtitleView(text: error, isError: true)
            } else if let helperText {
                subtitleView(text: helperText, isError: false)
            }
        }
    }

    private func subtitleView(text: String, isError: Bool) -> some View {
        HStack(spacing: TANDASpacing.sm) {
            Image(systemName: isError ? "exclamationmark.circle.fill" : "checkmark.circle.fill")
                .foregroundStyle(isError ? TANDAColors.Feedback.red : TANDAColors.Neutral.n400)
                .font(.system(size: 20))

            Text(text)
                .font(TANDATypography.Paragraph.m)
                .foregroundStyle(isError ? TANDAColors.Feedback.red : TANDAColors.Neutral.n700)
        }
        .padding(.top, TANDASpacing.md)
    }

    // MARK: - Keyboard Type

    private var keyboardType: UIKeyboardType {
        switch type {
        case .text: return .default
        case .amount: return .decimalPad
        case .password: return .default
        case .search: return .default
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

#Preview("Input Sizes") {
    ScrollView {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                Text("Standard Size")
                    .font(TANDATypography.Label.m)
                    .foregroundStyle(TANDAColors.Neutral.n500)
                Input(
                    text: .constant("500.00"),
                    type: .amount,
                    size: .standard,
                    label: "Amount"
                )
            }

            VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                Text("Large Size")
                    .font(TANDATypography.Label.m)
                    .foregroundStyle(TANDAColors.Neutral.n500)
                Input(
                    text: .constant("500.00"),
                    type: .amount,
                    size: .large,
                    label: "Amount"
                )
            }

            VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                Text("Large Password")
                    .font(TANDATypography.Label.m)
                    .foregroundStyle(TANDAColors.Neutral.n500)
                Input(
                    text: .constant("password123"),
                    type: .password,
                    size: .large,
                    label: "Password",
                    placeholder: "Enter password"
                )
            }

            VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                Text("Large with Error")
                    .font(TANDATypography.Label.m)
                    .foregroundStyle(TANDAColors.Neutral.n500)
                Input(
                    text: .constant("invalid"),
                    size: .large,
                    label: "Email",
                    error: "Please enter a valid email"
                )
            }
        }
        .padding(24)
    }
    .background(Color.white)
}

#Preview("Input Underlined Style") {
    ScrollView {
        VStack(spacing: 32) {
            Input(
                text: .constant("Nicholas"),
                style: .underlined,
                label: "Legal First Name"
            )

            Input(
                text: .constant(""),
                style: .underlined,
                label: "Legal Last Name",
                placeholder: "Enter your last name"
            )

            Input(
                text: .constant("nicholas@example.com"),
                style: .underlined,
                label: "Email",
                helperText: "Email address verified"
            )

            Input(
                text: .constant("nicholas@example.com"),
                style: .underlined,
                label: "Email",
                error: "Email address unverified. Check your email to verify."
            )

            Input(
                text: .constant("password123"),
                type: .password,
                style: .underlined,
                label: "Password",
                placeholder: "Enter password"
            )

            Input(
                text: .constant("1000.00"),
                type: .amount,
                style: .underlined,
                label: "Contribution Amount"
            )

            Input(
                text: .constant("Disabled text"),
                style: .underlined,
                label: "Disabled Field",
                isDisabled: true
            )
        }
        .padding(24)
    }
    .background(Color.white)
}
