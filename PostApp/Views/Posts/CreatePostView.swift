//
//  CreatePostView.swift
//  PostApp
//
//  Created on 23/5/25.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var subtitle = ""
    @State private var attributedBody = NSAttributedString(string: "")
    @State private var selectedRange = NSRange(location: 0, length: 0)
    @State private var isCreating = false
    @State private var showingError = false
    @State private var errorMessage = ""

    let repository: PostsRepository

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !subtitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !attributedBody.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    Section("Post Information") {
                        TextField("Title", text: $title, axis: .vertical)
                            .lineLimit(1...3)

                        TextField("Subtitle", text: $subtitle, axis: .vertical)
                            .lineLimit(1...3)
                    }

                    Section("Content") {
                        RichTextEditor(
                            attributedText: $attributedBody,
                            selectedRange: $selectedRange,
                            onTextChange: { _ in }
                        )
                        .frame(minHeight: 200)
                    }
                }

                // Rich text toolbar
                RichTextToolbar(
                    attributedText: $attributedBody,
                    selectedRange: $selectedRange
                )
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(isCreating)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        Task {
                            await createPost()
                        }
                    }
                    .disabled(!isFormValid || isCreating)
                }
            }
            .disabled(isCreating)
            .overlay {
                if isCreating {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .overlay {
                            ProgressView("Creating post...")
                                .padding()
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }

        private func createPost() async {
        isCreating = true

        do {
            // Convert NSAttributedString to HTML for storage
            let htmlBody = attributedBody.toHTML()

            try await repository.createPost(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                subtitle: subtitle.trimmingCharacters(in: .whitespacesAndNewlines),
                body: attributedBody.string.trimmingCharacters(in: .whitespacesAndNewlines),
                htmlBody: htmlBody
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }

        isCreating = false
    }
}

#Preview {
    CreatePostView(repository: PostsRepository())
}
