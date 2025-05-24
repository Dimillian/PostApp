//
//  PostDetailView.swift
//  PostApp
//
//  Created on 23/5/25.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    let readingGoalRepository: ReadingGoalRepository
    @Environment(\.dismiss) private var dismiss
    @State private var hasMarkedAsRead = false

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: post.createdAt)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(post.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text(post.subtitle)
                            .font(.title3)
                            .foregroundStyle(.secondary)

                        HStack {
                            Text(formattedDate)
                                .font(.caption)
                                .foregroundStyle(.tertiary)

                            if readingGoalRepository.hasReadPost(post.id) {
                                Label("Read", systemImage: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                    }
                    .padding(.horizontal)

                    Divider()

                    // Display rich text content
                    Text(post.attributedBody)
                        .font(.body)
                        .padding(.horizontal)
                        .textSelection(.enabled)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .task {
                // Mark as read after a short delay to ensure the user actually opened the post
                if !hasMarkedAsRead {
                    try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                    await readingGoalRepository.markPostAsRead(post.id)
                    hasMarkedAsRead = true
                }
            }
        }
    }
}

#Preview {
    PostDetailView(
        post: Post(
            title: "Sample Post Title",
            subtitle: "This is a sample subtitle for the post",
            body: """
            This is the body content of the post. It can be quite long and contain multiple paragraphs.

            Here's another paragraph with more content to show how the layout works with longer text.

            And a third paragraph to really demonstrate the scrolling functionality.
            """,
            htmlBody: """
            <p>This is the <b>body content</b> of the post. It can be quite long and contain <i>multiple paragraphs</i>.</p>

            <p>Here's another paragraph with <u>more content</u> to show how the layout works with longer text.</p>

            <p>And a <span style="color: blue;">third paragraph</span> to really demonstrate the scrolling functionality.</p>
            """
        ),
        readingGoalRepository: ReadingGoalRepository()
    )
}
