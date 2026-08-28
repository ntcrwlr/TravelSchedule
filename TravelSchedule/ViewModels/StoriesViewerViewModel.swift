import Combine
import Foundation
import SwiftUI

@MainActor
final class StoriesViewerViewModel: ObservableObject {
    static let pageDuration: TimeInterval = 10

    let stories: [Story]

    @Published private(set) var storyIndex: Int
    @Published private(set) var pageIndex: Int = 0
    @Published private(set) var progress: CGFloat = 0

    private var startedAt: Date?
    private var isPaused = false
    private var isActive = false
    private let onFinished: () -> Void
    private let onStoryViewed: (Int) -> Void

    init(
        stories: [Story],
        startIndex: Int,
        onStoryViewed: @escaping (Int) -> Void,
        onFinished: @escaping () -> Void
    ) {
        self.stories = stories
        self.storyIndex = min(max(startIndex, 0), max(stories.count - 1, 0))
        self.onStoryViewed = onStoryViewed
        self.onFinished = onFinished
    }

    var currentStory: Story {
        stories[storyIndex]
    }

    var currentPage: StoryPage {
        currentStory.pages[pageIndex]
    }

    func progress(for page: Int) -> CGFloat {
        if page < pageIndex { return 1 }
        if page > pageIndex { return 0 }
        return progress
    }

    func start() async {
        markCurrentViewed()
        isActive = true
        await runProgressLoop()
    }

    func showNext() {
        if pageIndex + 1 < currentStory.pages.count {
            pageIndex += 1
            restartTimer()
            return
        }

        if storyIndex + 1 < stories.count {
            storyIndex += 1
            pageIndex = 0
            markCurrentViewed()
            restartTimer()
            return
        }

        finish()
    }

    func showPrevious() {
        if pageIndex > 0 {
            pageIndex -= 1
            restartTimer()
            return
        }

        if storyIndex > 0 {
            storyIndex -= 1
            pageIndex = currentStory.pages.count - 1
            markCurrentViewed()
            restartTimer()
        } else {
            restartTimer()
        }
    }

    func pause() {
        isPaused = true
    }

    func resume() {
        guard isPaused else { return }
        isPaused = false
        let remaining = max(0.05, Self.pageDuration * Double(1 - progress))
        startedAt = Date().addingTimeInterval(-(Self.pageDuration - remaining))
    }

    func stopTimer() {
        isActive = false
    }

    private func finish() {
        isActive = false
        onFinished()
    }

    private func markCurrentViewed() {
        onStoryViewed(currentStory.id)
    }

    private func restartTimer() {
        progress = 0
        isPaused = false
        startedAt = Date()
    }

    private func runProgressLoop() async {
        restartTimer()

        for await date in Timer.publish(every: 1.0 / 30.0, on: .main, in: .common).autoconnect().values {
            guard isActive else { return }
            guard !isPaused, let startedAt else { continue }

            let elapsed = date.timeIntervalSince(startedAt)
            let value = min(1, CGFloat(elapsed / Self.pageDuration))
            progress = value
            if value >= 1 {
                showNext()
                if !isActive {
                    return
                }
            }
        }
    }
}
