//
//  PostsListView.swift
//  PostApp
//
//  Created on 23/5/25.
//

import SwiftUI

struct PostsListView: View {
    @State private var repository = PostsRepository()
    @State private var readingGoalRepository = ReadingGoalRepository()
    @State private var selectedPost: Post?
    @State private var showingCreatePost = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Reading Goal Widget
                    ReadingGoalWidget(repository: readingGoalRepository)
                        .padding(.top, 10)

                    // Posts Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Posts")
                            .font(.title2.bold())
                            .padding(.horizontal)

                        if repository.isLoading && repository.posts.isEmpty {
                            ProgressView("Loading posts...")
                                .frame(maxWidth: .infinity, minHeight: 200)
                        } else if repository.posts.isEmpty {
                            ContentUnavailableView(
                                "No Posts Yet",
                                systemImage: "doc.text",
                                description: Text("Tap the + button to create your first post")
                            )
                            .frame(minHeight: 200)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(repository.posts) { post in
                                    PostCardView(
                                        post: post,
                                        isRead: readingGoalRepository.hasReadPost(post.id)
                                    )
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedPost = post
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .refreshable {
                await repository.fetchPosts()
            }
            .navigationTitle("PostApp")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingCreatePost = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                await repository.fetchPosts()
            }
            .sheet(item: $selectedPost) { post in
                PostDetailView(post: post, readingGoalRepository: readingGoalRepository)
            }
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView(repository: repository)
            }
        }
    }
}

// New card view for posts with read indicator
struct PostCardView: View {
    let post: Post
    let isRead: Bool

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: post.createdAt)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Read indicator
            Circle()
                .fill(isRead ? Color.green : Color.gray.opacity(0.3))
                .frame(width: 8, height: 8)
                .offset(y: 8)

            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundStyle(isRead ? .secondary : .primary)

                Text(post.subtitle)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundStyle(isRead ? .tertiary : .secondary)

                HStack {
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundStyle(.tertiary)

                    if isRead {
                        Label("Read", systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(white: isRead ? 0.98 : 0.96))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    PostsListView()
}
