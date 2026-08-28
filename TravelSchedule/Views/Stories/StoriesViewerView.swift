import SwiftUI

struct StoriesViewerView: View {
    @StateObject private var viewModel: StoriesViewerViewModel
    @State private var dragOffset: CGSize = .zero
    private let onClose: () -> Void

    init(
        stories: [Story],
        startIndex: Int,
        onStoryViewed: @escaping (Int) -> Void,
        onClose: @escaping () -> Void
    ) {
        self.onClose = onClose
        _viewModel = StateObject(
            wrappedValue: StoriesViewerViewModel(
                stories: stories,
                startIndex: startIndex,
                onStoryViewed: onStoryViewed,
                onFinished: onClose
            )
        )
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()

                storyCard(size: geometry.size)
                    .offset(y: max(0, dragOffset.height))
                    .gesture(dragGesture)
            }
            .ignoresSafeArea()
        }
        .statusBarHidden()
        .task {
            await viewModel.start()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }

    private func storyCard(size: CGSize) -> some View {
        let cardWidth = size.width
        let cardHeight = size.height

        return ZStack {
            Image(viewModel.currentPage.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.35), .clear, .black.opacity(0.55)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(spacing: 0) {
                progressBars
                    .padding(.top, 54)
                    .padding(.horizontal, 12)

                Spacer()

                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.currentPage.title)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(AppColor.white)
                        .lineLimit(2)

                    Text(viewModel.currentPage.text)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(AppColor.white)
                        .lineLimit(3)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 48)
            }
            .allowsHitTesting(false)

            HStack(spacing: 0) {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.showPrevious() }

                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.showNext() }
            }
            .padding(.top, 110)
            .padding(.bottom, 160)

            VStack {
                HStack {
                    Spacer()
                    Button {
                        close()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(AppColor.white)
                            .frame(width: 30, height: 30)
                            .background(Circle().fill(Color.black.opacity(0.4)))
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 70)
                    .padding(.trailing, 16)
                }
                Spacer()
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
    }

    private var progressBars: some View {
        HStack(spacing: 4) {
            ForEach(Array(viewModel.currentStory.pages.enumerated()), id: \.element.id) { index, _ in
                GeometryReader { proxy in
                    Capsule()
                        .fill(Color.white.opacity(0.35))
                        .overlay(alignment: .leading) {
                            Capsule()
                                .fill(AppColor.blue)
                                .frame(width: proxy.size.width * viewModel.progress(for: index))
                        }
                }
                .frame(height: 4)
            }
        }
    }

    private func close() {
        viewModel.stopTimer()
        onClose()
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onChanged { value in
                let horizontal = abs(value.translation.width)
                let vertical = abs(value.translation.height)

                if vertical > horizontal {
                    viewModel.pause()
                    dragOffset = CGSize(width: 0, height: max(0, value.translation.height))
                }
            }
            .onEnded { value in
                let vertical = value.translation.height
                let horizontal = value.translation.width

                if vertical > 120 {
                    close()
                    return
                }

                withAnimation(.easeOut(duration: 0.2)) {
                    dragOffset = .zero
                }

                if abs(horizontal) > abs(vertical), abs(horizontal) > 50 {
                    if horizontal < 0 {
                        viewModel.showNext()
                    } else {
                        viewModel.showPrevious()
                    }
                } else {
                    viewModel.resume()
                }
            }
    }
}

#Preview {
    StoriesViewerView(
        stories: SampleStories.all,
        startIndex: 0,
        onStoryViewed: { _ in },
        onClose: {}
    )
}
