//
//  SupabaseService.swift
//  PostApp
//
//  Created on 23/5/25.
//

import Foundation

// Temporary mock implementation until Supabase SDK is added
@Observable
final class SupabaseService {
    static let shared = SupabaseService()

    // Mock data storage
    private var mockPosts: [Post] = []

    private init() {
        // Initialize with some mock data
        mockPosts = [
            Post(
                id: UUID(),
                title: "Welcome to PostApp",
                subtitle: "Your first blog post",
                body: "This is a sample blog post to demonstrate the app functionality. You can create, view, and manage your blog posts here.",
                createdAt: Date().addingTimeInterval(-3600)
            ),
            Post(
                id: UUID(),
                title: "Getting Started with SwiftUI",
                subtitle: "Modern iOS Development",
                body: "SwiftUI is Apple's modern declarative framework for building user interfaces across all Apple platforms. It provides a powerful and intuitive way to build apps.",
                createdAt: Date().addingTimeInterval(-7200)
            )
        ]
    }

    // MARK: - Posts Operations

    func fetchPosts() async throws -> [Post] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return mockPosts.sorted { $0.createdAt > $1.createdAt }
    }

    func fetchPost(id: UUID) async throws -> Post? {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        return mockPosts.first { $0.id == id }
    }

    func createPost(_ post: Post) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        mockPosts.append(post)
    }

    func updatePost(_ post: Post) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        if let index = mockPosts.firstIndex(where: { $0.id == post.id }) {
            mockPosts[index] = post
        }
    }

    func deletePost(id: UUID) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        mockPosts.removeAll { $0.id == id }
    }
}
