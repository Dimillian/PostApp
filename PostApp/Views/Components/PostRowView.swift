//
//  PostRowView.swift
//  PostApp
//
//  Created on 23/5/25.
//

import SwiftUI

struct PostRowView: View {
    let post: Post

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: post.createdAt)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.headline)
                .lineLimit(2)
                .foregroundStyle(.primary)

            Text(post.subtitle)
                .font(.subheadline)
                .lineLimit(2)
                .foregroundStyle(.secondary)

            Text(formattedDate)
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PostRowView(post: Post(
        title: "Sample Post Title",
        subtitle: "This is a sample subtitle for the post",
        body: "This is the body content of the post"
    ))
    .padding()
}
