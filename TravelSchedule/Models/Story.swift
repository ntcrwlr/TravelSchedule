import Foundation

struct StoryPage: Identifiable, Hashable {
    let id: Int
    let imageName: String
    let title: String
    let text: String
}

struct Story: Identifiable, Hashable {
    let id: Int
    let previewImageName: String
    let pages: [StoryPage]
}

enum SampleStories {
    static let all: [Story] = (0..<6).map { storyIndex in
        let firstImage = storyIndex * 3 + 1
        let pageImages = [firstImage, firstImage + 1, firstImage + 2].map(String.init)
        return Story(
            id: storyIndex,
            previewImageName: pageImages[0],
            pages: pageImages.enumerated().map { pageIndex, imageName in
                StoryPage(
                    id: storyIndex * 10 + pageIndex,
                    imageName: imageName,
                    title: AppStrings.storyTitle,
                    text: AppStrings.storyText
                )
            }
        )
    }
}
