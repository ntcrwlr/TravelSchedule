import Combine
import Foundation

@MainActor
final class ScheduleSearchViewModel: ObservableObject {
    @Published var from: RoutePoint?
    @Published var to: RoutePoint?
    @Published var presentedStoryID: Int?

    let carriersViewModel = CarriersListViewModel()
    let storiesStore = StoriesStore.shared

    var canFind: Bool {
        from != nil && to != nil
    }

    var isStoriesPresented: Bool {
        presentedStoryID != nil
    }

    func swapStations() {
        let currentFrom = from
        from = to
        to = currentFrom
    }

    func setRoutePoint(_ point: RoutePoint, direction: CitySearchDirection) {
        switch direction {
        case .from:
            from = point
        case .to:
            to = point
        }
    }

    func makeRoutePoint(city: City, station: Station) -> RoutePoint {
        RoutePoint(id: station.id, title: "\(city.title) (\(station.title))")
    }

    func prepareCarriersSearch() {
        carriersViewModel.configure(from: from, to: to)
    }

    func openStory(id: Int) {
        presentedStoryID = id
    }

    func closeStories() {
        presentedStoryID = nil
    }
}
