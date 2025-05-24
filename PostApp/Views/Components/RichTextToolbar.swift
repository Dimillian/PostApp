import SwiftUI
import UIKit

struct RichTextToolbar: View {
    @Binding var attributedText: NSAttributedString
    @Binding var selectedRange: NSRange

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                // Bold
                Button(action: toggleBold) {
                    Image(systemName: "bold")
                        .foregroundColor(isBold ? .accentColor : .primary)
                }

                // Italic
                Button(action: toggleItalic) {
                    Image(systemName: "italic")
                        .foregroundColor(isItalic ? .accentColor : .primary)
                }

                // Underline
                Button(action: toggleUnderline) {
                    Image(systemName: "underline")
                        .foregroundColor(isUnderlined ? .accentColor : .primary)
                }

                Divider()
                    .frame(height: 20)

                // Text size
                Menu {
                    Button("Small") { setTextSize(.caption) }
                    Button("Normal") { setTextSize(.body) }
                    Button("Large") { setTextSize(.title3) }
                    Button("Extra Large") { setTextSize(.title) }
                } label: {
                    Image(systemName: "textformat.size")
                }

                Divider()
                    .frame(height: 20)

                // Text color
                Menu {
                    Button(action: { setTextColor(.primary) }) {
                        Label("Default", systemImage: "circle")
                    }
                    Button(action: { setTextColor(.red) }) {
                        Label("Red", systemImage: "circle.fill")
                            .foregroundColor(.red)
                    }
                    Button(action: { setTextColor(.blue) }) {
                        Label("Blue", systemImage: "circle.fill")
                            .foregroundColor(.blue)
                    }
                    Button(action: { setTextColor(.green) }) {
                        Label("Green", systemImage: "circle.fill")
                            .foregroundColor(.green)
                    }
                    Button(action: { setTextColor(.orange) }) {
                        Label("Orange", systemImage: "circle.fill")
                            .foregroundColor(.orange)
                    }
                    Button(action: { setTextColor(.purple) }) {
                        Label("Purple", systemImage: "circle.fill")
                            .foregroundColor(.purple)
                    }
                } label: {
                    Image(systemName: "paintpalette")
                }

                Divider()
                    .frame(height: 20)

                // Clear formatting
                Button(action: clearFormatting) {
                    Image(systemName: "clear")
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 44)
        .background(Color(UIColor.systemGray6))
    }

    // MARK: - Formatting State

    private var isBold: Bool {
        guard selectedRange.location != NSNotFound else { return false }
        let attributes = attributedText.attributes(at: max(0, selectedRange.location - 1), effectiveRange: nil)
        if let font = attributes[.font] as? UIFont {
            return font.fontDescriptor.symbolicTraits.contains(.traitBold)
        }
        return false
    }

    private var isItalic: Bool {
        guard selectedRange.location != NSNotFound else { return false }
        let attributes = attributedText.attributes(at: max(0, selectedRange.location - 1), effectiveRange: nil)
        if let font = attributes[.font] as? UIFont {
            return font.fontDescriptor.symbolicTraits.contains(.traitItalic)
        }
        return false
    }

    private var isUnderlined: Bool {
        guard selectedRange.location != NSNotFound else { return false }
        let attributes = attributedText.attributes(at: max(0, selectedRange.location - 1), effectiveRange: nil)
        return attributes[.underlineStyle] != nil
    }

    // MARK: - Formatting Actions

    private func toggleBold() {
        applyFontTrait(.traitBold)
    }

    private func toggleItalic() {
        applyFontTrait(.traitItalic)
    }

    private func toggleUnderline() {
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)

        if selectedRange.length > 0 {
            let currentUnderline = mutableAttributedText.attribute(NSAttributedString.Key.underlineStyle, at: selectedRange.location, effectiveRange: nil) as? Int

            if currentUnderline == nil || currentUnderline == 0 {
                mutableAttributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: selectedRange)
            } else {
                mutableAttributedText.removeAttribute(NSAttributedString.Key.underlineStyle, range: selectedRange)
            }
        }

        attributedText = mutableAttributedText
    }

    private func applyFontTrait(_ trait: UIFontDescriptor.SymbolicTraits) {
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)

        if selectedRange.length > 0 {
            mutableAttributedText.enumerateAttribute(NSAttributedString.Key.font, in: selectedRange, options: []) { value, range, _ in
                if let font = value as? UIFont {
                    var traits = font.fontDescriptor.symbolicTraits

                    if traits.contains(trait) {
                        traits.remove(trait)
                    } else {
                        traits.insert(trait)
                    }

                    if let descriptor = font.fontDescriptor.withSymbolicTraits(traits) {
                        let newFont = UIFont(descriptor: descriptor, size: font.pointSize)
                        mutableAttributedText.addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
                    }
                }
            }
        }

        attributedText = mutableAttributedText
    }

    private func setTextSize(_ textStyle: Font.TextStyle) {
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)

        let fontSize: CGFloat = {
            switch textStyle {
            case .caption: return 12
            case .body: return 17
            case .title3: return 20
            case .title: return 28
            default: return 17
            }
        }()

        if selectedRange.length > 0 {
            mutableAttributedText.enumerateAttribute(NSAttributedString.Key.font, in: selectedRange, options: []) { value, range, _ in
                if let font = value as? UIFont {
                    let newFont = font.withSize(fontSize)
                    mutableAttributedText.addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
                }
            }
        }

        attributedText = mutableAttributedText
    }

    private func setTextColor(_ color: Color) {
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)

        if selectedRange.length > 0 {
            mutableAttributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(color), range: selectedRange)
        }

        attributedText = mutableAttributedText
    }

    private func clearFormatting() {
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)

        if selectedRange.length > 0 {
            // Remove all attributes
            let attributes: [NSAttributedString.Key] = [.font, .foregroundColor, .underlineStyle, .strikethroughStyle]
            for attribute in attributes {
                mutableAttributedText.removeAttribute(attribute, range: selectedRange)
            }

            // Apply default font
            let defaultFont = UIFont.preferredFont(forTextStyle: .body)
            mutableAttributedText.addAttribute(NSAttributedString.Key.font, value: defaultFont, range: selectedRange)
        }

        attributedText = mutableAttributedText
    }
}
