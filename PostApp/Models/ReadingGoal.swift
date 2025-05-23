//
//  ReadingGoal.swift
//  PostApp
//
//  Created on 23/5/25.
//

import Foundation

struct ReadingGoal: Codable {
    let dailyGoal: Int
    var postsReadToday: Set<UUID>
    var lastResetDate: Date

    init(dailyGoal: Int = 5) {
        self.dailyGoal = dailyGoal
        self.postsReadToday = []
        self.lastResetDate = Date()
    }

    var readCount: Int {
        postsReadToday.count
    }

    var progress: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(Double(readCount) / Double(dailyGoal), 1.0)
    }

    var isGoalReached: Bool {
        readCount >= dailyGoal
    }

    mutating func markPostAsRead(_ postId: UUID) {
        postsReadToday.insert(postId)
    }

    mutating func resetIfNeeded() {
        let calendar = Calendar.current
        if !calendar.isDateInToday(lastResetDate) {
            postsReadToday.removeAll()
            lastResetDate = Date()
        }
    }
}
