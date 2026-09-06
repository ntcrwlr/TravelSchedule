import Combine
import Foundation

@MainActor
final class StationSearchViewModel: ObservableObject {
    let city: City

    @Published var query = ""

    var filteredStations: [Station] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return city.stations }
        return city.stations.filter { $0.title.localizedCaseInsensitiveContains(trimmed) }
    }

    init(city: City) {
        self.city = city
    }
}
