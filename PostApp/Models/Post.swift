//
//  Post.swift
//  PostApp
//
//  Created on 23/5/25.
//

import Foundation
import SwiftUI

struct Post: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let subtitle: String
    let body: String
    let htmlBody: String? // Store rich text as HTML for better compatibility
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case body
        case htmlBody = "html_body"
        case createdAt = "created_at"
    }

    init(id: UUID = UUID(), title: String, subtitle: String, body: String, htmlBody: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.htmlBody = htmlBody
        self.createdAt = createdAt
    }

    // Computed property to get AttributedString from HTML
    var attributedBody: AttributedString {
        if let htmlBody = htmlBody,
           let data = htmlBody.data(using: .utf8),
           let nsAttributedString = try? NSAttributedString(
               data: data,
               options: [.documentType: NSAttributedString.DocumentType.html,
                        .characterEncoding: String.Encoding.utf8.rawValue],
               documentAttributes: nil
           ) {
            return nsAttributedString.toAttributedString()
        }
        // Fallback to plain text
        return AttributedString(body)
    }
}
