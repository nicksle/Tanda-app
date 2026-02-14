import SwiftUI

// MARK: - TANDA Color Tokens
// Single source of truth for all colors in the TANDA design system.
// Matches Figma variables 1:1.

struct TANDAColors {
    
    // MARK: - Primitives — Neutrals
    struct Neutral {
        static let n0   = Color(hex: "#FFFFFF")
        static let n50  = Color(hex: "#F9FAFB")
        static let n100 = Color(hex: "#F3F4F6")
        static let n200 = Color(hex: "#E5E7EB")
        static let n300 = Color(hex: "#D1D5DB")
        static let n400 = Color(hex: "#9CA3AF")
        static let n500 = Color(hex: "#6B7280")
        static let n600 = Color(hex: "#4B5563")
        static let n700 = Color(hex: "#374151")
        static let n800 = Color(hex: "#1F2937")
        static let n900 = Color(hex: "#111827")
        static let n950 = Color(hex: "#030712")
    }
    
    // MARK: - Primitives — Brand Purple
    struct Purple {
        static let p100 = Color(hex: "#EDE9FE")
        static let p200 = Color(hex: "#DDD6FE")
        static let p300 = Color(hex: "#C4B5FD")
        static let p400 = Color(hex: "#A78BFA")
        static let p500 = Color(hex: "#8B5CF6") // ★ Primary
        static let p600 = Color(hex: "#7C3AED")
        static let p700 = Color(hex: "#6D28D9")
        static let p800 = Color(hex: "#5B21B6")
        static let p900 = Color(hex: "#4C1D95")
    }
    
    // MARK: - Primitives — Secondary
    struct Secondary {
        static let coral      = Color(hex: "#F68896")
        static let violet     = Color(hex: "#AE65EC")
        static let magenta    = Color(hex: "#D85ACE")
        static let orange     = Color(hex: "#FE742A")
        static let deepPurple = Color(hex: "#31005C")
        static let periwinkle = Color(hex: "#BBC8F1")
    }
    
    // MARK: - Primitives — Feedback
    struct Feedback {
        static let redLight    = Color(hex: "#FEE2E2")
        static let red         = Color(hex: "#EF4444")
        static let greenLight  = Color(hex: "#DCFCE7")
        static let green       = Color(hex: "#22C55E")
        static let yellowLight = Color(hex: "#FEF3C7")
        static let yellow      = Color(hex: "#F59E0B")
        static let blueLight   = Color(hex: "#DBEAFE")
        static let blue        = Color(hex: "#3B82F6")
    }
    
    // MARK: - Semantic Tokens
    // These adapt automatically based on color scheme.
    
    struct Surface {
        static let primary   = Color("surface.primary")
        static let secondary = Color("surface.secondary")
        static let tertiary  = Color("surface.tertiary")
        
        // Fallbacks for when asset catalog isn't set up yet
        static func primary(for scheme: ColorScheme) -> Color {
            scheme == .dark ? Neutral.n900 : Neutral.n0
        }
        static func secondary(for scheme: ColorScheme) -> Color {
            scheme == .dark ? Neutral.n800 : Neutral.n50
        }
        static func tertiary(for scheme: ColorScheme) -> Color {
            scheme == .dark ? Neutral.n700 : Neutral.n100
        }
    }
    
    struct Text {
        // Light mode colors (app is locked to light mode)
        static let primary   = Neutral.n900 // Black
        static let secondary = Neutral.n500 // Medium grey
        static let tertiary  = Neutral.n400 // Light grey

        // Fallbacks for future dark mode support
        static func primary(for scheme: ColorScheme) -> Color {
            scheme == .dark ? Neutral.n0 : Neutral.n900
        }
        static func secondary(for scheme: ColorScheme) -> Color {
            scheme == .dark ? Neutral.n400 : Neutral.n500
        }
        static func tertiary(for scheme: ColorScheme) -> Color {
            scheme == .dark ? Neutral.n500 : Neutral.n400
        }
    }
    
    struct Brand {
        static let primary   = Purple.p500
        static let secondary = Purple.p600

        // Social Feed / Figma Brand Colors
        static let black1 = Color(hex: "#05031E")  // Darkest text
        static let black2 = Color(hex: "#66666E")  // Secondary text
        static let black3 = Color(hex: "#99999E")  // Tertiary text/metadata
        static let white2 = Color(hex: "#F6F6F8")  // Balance card background
        static let white3 = Color(hex: "#EDEDF0")  // Borders/dividers
        static let accentPurple = Color(hex: "#A052FE")  // Action purple
        static let successGreen = Color(hex: "#19D22B")  // Positive transaction amounts
    }

    // MARK: - Common Aliases
    static let border = Neutral.n700
    static let divider = Brand.white3
}

// MARK: - Color Hex Initializer

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
