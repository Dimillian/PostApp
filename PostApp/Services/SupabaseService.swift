//
//  SupabaseService.swift
//  PostApp
//
//  Created on 23/5/25.
//

import Foundation
import Supabase

private struct SupabaseSecrets: Decodable {
    let supabaseUrl: String
    let supabaseKey: String
}

private func loadSupabaseSecrets() -> SupabaseSecrets {
    guard let url = Bundle.main.url(forResource: "Secret", withExtension: "plist"),
          let data = try? Data(contentsOf: url),
          let secrets = try? PropertyListDecoder().decode(SupabaseSecrets.self, from: data) else {
        fatalError("Missing or invalid Secret.plist. Please create one with supabaseUrl and supabaseKey.")
    }
    return secrets
}

@Observable
final class SupabaseService {
    static let shared = SupabaseService()

    private let client: SupabaseClient

    private init() {
        let secrets = loadSupabaseSecrets()
        guard let supabaseUrl = URL(string: secrets.supabaseUrl) else {
            fatalError("Invalid Supabase URL in Secret.plist")
        }
        client = SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: secrets.supabaseKey)
    }

    // MARK: - Posts Operations

    func fetchPosts() async throws -> [Post] {
        let posts: [Post] = try await client.from("posts")
            .select()
            .order("created_at", ascending: false)
            .execute()
            .value
        return posts
    }

    func fetchPost(id: UUID) async throws -> Post? {
        let post: Post = try await client.from("posts")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
        return post
    }

    func createPost(_ post: Post) async throws {
        let isoDate = ISO8601DateFormatter().string(from: post.createdAt)
        _ = try await client.from("posts")
            .insert([
                [
                    "id": post.id.uuidString,
                    "title": post.title,
                    "subtitle": post.subtitle,
                    "body": post.body,
                    "html_body": post.htmlBody,
                    "created_at": isoDate
                ]
            ])
            .execute()
    }

    func updatePost(_ post: Post) async throws {
        _ = try await client.from("posts")
            .update([
                "title": post.title,
                "subtitle": post.subtitle,
                "body": post.body,
                "html_body": post.htmlBody
            ])
            .eq("id", value: post.id.uuidString)
            .execute()
    }

    func deletePost(id: UUID) async throws {
        _ = try await client.from("posts")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }
}
