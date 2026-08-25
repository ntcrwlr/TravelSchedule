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

    private var timer: AnyCancellable?
    private var startedAt: Date?
    private var isPaused = false
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
        markCurrentViewed()
        startTimer()
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

        stopTimer()
        onFinished()
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
        timer?.cancel()
        timer = nil
    }

    func resume() {
        guard isPaused else { return }
        isPaused = false
        let remaining = max(0.05, Self.pageDuration * Double(1 - progress))
        startedAt = Date().addingTimeInterval(-(Self.pageDuration - remaining))
        startTimer(resume: true)
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    private func markCurrentViewed() {
        onStoryViewed(currentStory.id)
    }

    private func restartTimer() {
        progress = 0
        isPaused = false
        startTimer()
    }

    private func startTimer(resume: Bool = false) {
        timer?.cancel()
        if !resume {
            progress = 0
            startedAt = Date()
        } else if startedAt == nil {
            startedAt = Date()
        }

        timer = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                guard let self, let startedAt = self.startedAt, !self.isPaused else { return }
                let elapsed = date.timeIntervalSince(startedAt)
                let value = min(1, CGFloat(elapsed / Self.pageDuration))
                self.progress = value
                if value >= 1 {
                    self.showNext()
                }
            }
    }
}
