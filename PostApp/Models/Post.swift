//
//  Post.swift
//  PostApp
//
//  Created on 23/5/25.
//

import Foundation

struct Post: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let subtitle: String
    let body: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case body
        case createdAt = "created_at"
    }

    init(id: UUID = UUID(), title: String, subtitle: String, body: String, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.createdAt = createdAt
    }
}
