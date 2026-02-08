import SwiftUI

// MARK: - TANDA Typography Tokens
// Purpose-driven type system using Post Grotesk.
// Categories: Display, Heading, Label, Paragraph.
//
// If Post Grotesk isn't installed, falls back to system font.
// Make sure to add PostGrotesk font files to the Xcode project
// and register them in Info.plist under "Fonts provided by application".

struct TANDATypography {
    
    // Change this to "PostGrotesk" once the font files are added.
    // Using system font as fallback for prototype.
    private static let fontName: String? = nil // Set to "PostGrotesk-Regular" when ready
    
    private static func font(size: CGFloat, weight: Font.Weight) -> Font {
        if let fontName {
            // Custom font with weight variants
            let weightSuffix: String
            switch weight {
            case .bold: weightSuffix = "Bold"
            case .semibold: weightSuffix = "SemiBold"
            case .medium: weightSuffix = "Medium"
            case .regular: weightSuffix = "Regular"
            default: weightSuffix = "Regular"
            }
            return Font.custom("PostGrotesk-\(weightSuffix)", size: size)
        } else {
            return Font.system(size: size, weight: weight)
        }
    }
    
    // MARK: - Display
    // Hero moments, splash screens. One per screen max.
    struct Display {
        static let xxl = font(size: 48, weight: .bold) // Line height: 56
        static let xl  = font(size: 40, weight: .bold) // Line height: 48
        static let l   = font(size: 34, weight: .bold) // Line height: 41
        static let m   = font(size: 28, weight: .bold) // Line height: 34
    }
    
    // MARK: - Heading
    // Section titles, screen hierarchy, structure.
    struct Heading {
        static let xl = font(size: 28, weight: .bold)     // Line height: 34
        static let l  = font(size: 22, weight: .bold)     // Line height: 28
        static let m  = font(size: 20, weight: .semibold) // Line height: 25
        static let s  = font(size: 17, weight: .semibold) // Line height: 22
    }
    
    // MARK: - Label
    // UI controls, buttons, tabs, form labels, navigation.
    struct Label {
        static let l  = font(size: 17, weight: .medium) // Line height: 22
        static let m  = font(size: 15, weight: .medium) // Line height: 20
        static let s  = font(size: 13, weight: .medium) // Line height: 18
        static let xs = font(size: 11, weight: .medium) // Line height: 13
    }
    
    // MARK: - Paragraph
    // Body copy, descriptions, readable long-form text.
    struct Paragraph {
        static let l = font(size: 17, weight: .regular) // Line height: 24
        static let m = font(size: 15, weight: .regular) // Line height: 22
        static let s = font(size: 13, weight: .regular) // Line height: 18
    }
}

// MARK: - Line Height Modifier
// SwiftUI doesn't have native line-height, so we use lineSpacing.

extension View {
    func tandaLineHeight(_ lineHeight: CGFloat, fontSize: CGFloat) -> some View {
        self.lineSpacing(lineHeight - fontSize)
    }
}
