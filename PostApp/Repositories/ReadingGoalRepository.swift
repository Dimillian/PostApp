//
//  ReadingGoalRepository.swift
//  PostApp
//
//  Created on 23/5/25.
//

import Foundation
import SwiftUI
import UIKit

@Observable
final class ReadingGoalRepository {
    private(set) var readingGoal: ReadingGoal {
        didSet {
            saveReadingGoal()
        }
    }

    private let userDefaults = UserDefaults.standard
    private let readingGoalKey = "ReadingGoalData"

    init() {
        // Load from UserDefaults or create new
        if let data = userDefaults.data(forKey: readingGoalKey),
           let goal = try? JSONDecoder().decode(ReadingGoal.self, from: data) {
            self.readingGoal = goal
            self.readingGoal.resetIfNeeded()
        } else {
            self.readingGoal = ReadingGoal()
        }
    }

    @MainActor
    func markPostAsRead(_ postId: UUID) {
        readingGoal.resetIfNeeded()

        // Only mark if not already read
        if !readingGoal.postsReadToday.contains(postId) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                readingGoal.markPostAsRead(postId)
            }

            // Trigger haptic feedback when goal is reached
            if readingGoal.isGoalReached && readingGoal.readCount == readingGoal.dailyGoal {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }
        }
    }

    func hasReadPost(_ postId: UUID) -> Bool {
        readingGoal.postsReadToday.contains(postId)
    }

    private func saveReadingGoal() {
        if let data = try? JSONEncoder().encode(readingGoal) {
            userDefaults.set(data, forKey: readingGoalKey)
        }
    }
}
