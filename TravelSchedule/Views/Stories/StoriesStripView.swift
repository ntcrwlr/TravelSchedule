import SwiftUI

struct StoriesStripView: View {
    @ObservedObject var store: StoriesStore
    let stories: [Story]
    let onSelect: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(stories) { story in
                    Button {
                        onSelect(story.id)
                    } label: {
                        StoryPreviewCard(
                            story: story,
                            isViewed: store.isViewed(story.id)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct StoryPreviewCard: View {
    let story: Story
    let isViewed: Bool

    private let size = CGSize(width: 92, height: 140)

    var body: some View {
        Image(story.previewImageName)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(alignment: .bottomLeading) {
                Text(AppStrings.storyPreviewText)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(AppColor.white)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .padding(8)
            }
            .opacity(isViewed ? 0.5 : 1)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isViewed ? Color.clear : AppColor.blue, lineWidth: 4)
            }
    }
}
