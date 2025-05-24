import SwiftUI
import UIKit

struct RichTextEditor: UIViewRepresentable {
    @Binding var attributedText: NSAttributedString
    @Binding var selectedRange: NSRange
    let onTextChange: (NSAttributedString) -> Void

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.attributedText = attributedText
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = UIColor.secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        textView.isScrollEnabled = true
        textView.keyboardDismissMode = .interactive

        // Enable rich text editing
        textView.allowsEditingTextAttributes = true

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.attributedText != attributedText {
            uiView.attributedText = attributedText
        }

        if uiView.selectedRange != selectedRange {
            uiView.selectedRange = selectedRange
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.attributedText = textView.attributedText
            parent.onTextChange(textView.attributedText)
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            parent.selectedRange = textView.selectedRange
        }
    }
}

// Extension to convert between NSAttributedString and AttributedString
extension NSAttributedString {
    func toAttributedString() -> AttributedString {
        do {
            let attributedString = try AttributedString(self, including: \.uiKit)
            return attributedString
        } catch {
            return AttributedString(string)
        }
    }
}

extension AttributedString {
    func toNSAttributedString() -> NSAttributedString {
        let nsAttributedString = NSAttributedString(self)
        return nsAttributedString
    }
}

// Extension to convert NSAttributedString to HTML
extension NSAttributedString {
    func toHTML() -> String? {
        do {
            let htmlData = try self.data(from: NSRange(location: 0, length: self.length),
                                       documentAttributes: [.documentType: NSAttributedString.DocumentType.html])
            return String(data: htmlData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
