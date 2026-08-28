import SwiftUI

struct ScheduleSearchView: View {
    @StateObject private var viewModel = ScheduleSearchViewModel()
    @State private var path = NavigationPath()

    private var isStoriesPresented: Binding<Bool> {
        Binding(
            get: { viewModel.isStoriesPresented },
            set: { if !$0 { viewModel.closeStories() } }
        )
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading, spacing: 16) {
                StoriesStripView(
                    store: viewModel.storiesStore,
                    stories: SampleStories.all
                ) { storyID in
                    viewModel.openStory(id: storyID)
                }

                searchCard
                    .padding(.horizontal, 16)

                if viewModel.canFind {
                    findButton
                        .frame(maxWidth: .infinity)
                }

                Spacer()
            }
            .padding(.top, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
            .appErrorOverlay()
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(path.isEmpty ? .visible : .hidden, for: .tabBar)
            .navigationDestination(for: ScheduleRoute.self) { route in
                switch route {
                case .citySearch(let direction):
                    CitySearchView(direction: direction)
                case .stationSearch(let direction, let city):
                    StationSearchView(city: city) { station in
                        let point = viewModel.makeRoutePoint(city: city, station: station)
                        viewModel.setRoutePoint(point, direction: direction)
                        path.removeLast(min(2, path.count))
                    }
                case .carriers:
                    CarriersListView(viewModel: viewModel.carriersViewModel, path: $path)
                case .timeFilter:
                    RouteFilterView(filters: viewModel.carriersViewModel.filters) { applied in
                        viewModel.carriersViewModel.filters = applied
                    }
                case .carrierCard(let code):
                    CarrierDetailsView(carrierCode: code)
                }
            }
            .fullScreenCover(isPresented: isStoriesPresented) {
                StoriesViewerView(
                    stories: SampleStories.all,
                    startIndex: viewModel.presentedStoryID ?? 0,
                    onStoryViewed: { storyID in
                        viewModel.storiesStore.markViewed(storyID)
                    },
                    onClose: {
                        viewModel.closeStories()
                    }
                )
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.canFind)
    }

    private var searchCard: some View {
        HStack(spacing: 16) {
            VStack(spacing: 0) {
                stationRow(point: viewModel.from, placeholder: AppStrings.from) {
                    path.append(ScheduleRoute.citySearch(.from))
                }

                Rectangle()
                    .fill(AppColor.lightGray)
                    .frame(height: 1)
                    .padding(.horizontal, 16)

                stationRow(point: viewModel.to, placeholder: AppStrings.to) {
                    path.append(ScheduleRoute.citySearch(.to))
                }
            }
            .background(AppColor.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            Button(action: viewModel.swapStations) {
                Image(systemName: "arrow.2.circlepath")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(AppColor.blue)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(AppColor.white))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(AppStrings.swapStations)
        }
        .padding(16)
        .background(AppColor.blue)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var findButton: some View {
        Button {
            viewModel.prepareCarriersSearch()
            path.append(ScheduleRoute.carriers)
        } label: {
            Text(AppStrings.find)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(AppColor.white)
                .frame(width: 150, height: 60)
                .background(AppColor.blue)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private func stationRow(
        point: RoutePoint?,
        placeholder: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(point?.title ?? placeholder)
                .font(.system(size: 17))
                .foregroundStyle(point == nil ? AppColor.gray : AppColor.black)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .frame(height: 48)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview("Пустые поля") {
    ScheduleSearchView()
}

#Preview("Тёмная тема") {
    ScheduleSearchView()
        .preferredColorScheme(.dark)
}
