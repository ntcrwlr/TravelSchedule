import Foundation
import Combine

@MainActor
final class StoriesStore: ObservableObject {
    static let shared = StoriesStore()

    @Published private(set) var viewedStoryIDs: Set<Int>

    private let storageKey = "viewedStoryIDs"

    private init() {
        if let saved = UserDefaults.standard.array(forKey: storageKey) as? [Int] {
            viewedStoryIDs = Set(saved)
        } else {
            viewedStoryIDs = []
        }
    }

    func isViewed(_ storyID: Int) -> Bool {
        viewedStoryIDs.contains(storyID)
    }

    func markViewed(_ storyID: Int) {
        guard !viewedStoryIDs.contains(storyID) else { return }
        viewedStoryIDs.insert(storyID)
        UserDefaults.standard.set(Array(viewedStoryIDs), forKey: storageKey)
    }
}
