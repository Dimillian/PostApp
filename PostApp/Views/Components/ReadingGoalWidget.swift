//
//  ReadingGoalWidget.swift
//  PostApp
//
//  Created on 23/5/25.
//

import SwiftUI

struct ReadingGoalWidget: View {
    @Bindable var repository: ReadingGoalRepository
    @State private var animateProgress = false

    private var gradient: LinearGradient {
        LinearGradient(
            colors: repository.readingGoal.isGoalReached
                ? [Color.green, Color.mint]
                : [Color.blue, Color.purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(white: 0.95),
                Color(white: 0.92)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Reading Goal")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(repository.readingGoal.isGoalReached ? "Goal Reached! 🎉" : "Keep reading!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: repository.readingGoal.isGoalReached ? "checkmark.circle.fill" : "book.fill")
                    .font(.title2)
                    .foregroundStyle(gradient)
                    .symbolEffect(.bounce, value: repository.readingGoal.isGoalReached)
            }

            // Gauge
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)

                // Progress circle
                Circle()
                    .trim(from: 0, to: animateProgress ? repository.readingGoal.progress : 0)
                    .stroke(gradient, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0, dampingFraction: 0.8), value: animateProgress)

                // Center content
                VStack(spacing: 8) {
                    Text("\(repository.readingGoal.readCount)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(gradient)
                        .contentTransition(.numericText())
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: repository.readingGoal.readCount)

                    Text("of \(repository.readingGoal.dailyGoal) posts")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 180, height: 180)

            // Progress bar (alternative view)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Progress")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("\(Int(repository.readingGoal.progress * 100))%")
                        .font(.caption.bold())
                        .foregroundStyle(gradient)
                        .contentTransition(.numericText())
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)

                        // Progress
                        RoundedRectangle(cornerRadius: 8)
                            .fill(gradient)
                            .frame(width: animateProgress ? geometry.size.width * repository.readingGoal.progress : 0, height: 8)
                            .animation(.spring(response: 1.0, dampingFraction: 0.8), value: animateProgress)
                    }
                }
                .frame(height: 8)
            }

            // Motivational message
            if !repository.readingGoal.isGoalReached {
                Text("Read \(repository.readingGoal.dailyGoal - repository.readingGoal.readCount) more post\(repository.readingGoal.dailyGoal - repository.readingGoal.readCount == 1 ? "" : "s") to reach your goal!")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundGradient)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateProgress = true
            }
        }
    }
}

#Preview {
    ReadingGoalWidget(repository: ReadingGoalRepository())
        .padding()
}
