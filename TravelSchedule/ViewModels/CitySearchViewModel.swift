import Combine
import Foundation

@MainActor
final class CitySearchViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var cities: [City] = []

    var filteredCities: [City] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return cities }
        return cities.filter { $0.title.localizedCaseInsensitiveContains(trimmed) }
    }

    func load() async {
        cities = SampleLocations.cities
    }
}
