//
//  PostsRepository.swift
//  PostApp
//
//  Created on 23/5/25.
//

import Foundation
import SwiftUI

@Observable
final class PostsRepository {
    private(set) var posts: [Post] = []
    private(set) var isLoading = false
    private(set) var error: Error?

    private let supabaseService = SupabaseService.shared

    // MARK: - Fetch Posts

    @MainActor
    func fetchPosts() async {
        isLoading = true
        error = nil

        do {
            posts = try await supabaseService.fetchPosts()
        } catch {
            self.error = error
            print("Error fetching posts: \(error)")
        }

        isLoading = false
    }

    // MARK: - Fetch Single Post

    @MainActor
    func fetchPost(id: UUID) async -> Post? {
        do {
            return try await supabaseService.fetchPost(id: id)
        } catch {
            self.error = error
            print("Error fetching post: \(error)")
            return nil
        }
    }

    // MARK: - Create Post

    @MainActor
    func createPost(title: String, subtitle: String, body: String, htmlBody: String? = nil) async throws {
        let newPost = Post(title: title, subtitle: subtitle, body: body, htmlBody: htmlBody)

        try await supabaseService.createPost(newPost)

        // Add to local array
        posts.insert(newPost, at: 0)
    }

    // MARK: - Delete Post

    @MainActor
    func deletePost(_ post: Post) async throws {
        try await supabaseService.deletePost(id: post.id)

        // Remove from local array
        posts.removeAll { $0.id == post.id }
    }
}
