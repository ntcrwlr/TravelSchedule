import SwiftUI

struct CitySearchView: View {
    let direction: CitySearchDirection

    @State private var query = ""

    private var filteredCities: [City] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return SampleLocations.cities }
        return SampleLocations.cities.filter { $0.title.localizedCaseInsensitiveContains(trimmed) }
    }

    var body: some View {
        SearchListScreen(
            title: AppStrings.citySearchTitle,
            emptyMessage: AppStrings.cityNotFound,
            isEmpty: filteredCities.isEmpty,
            query: $query
        ) {
            ForEach(filteredCities) { city in
                NavigationLink(value: ScheduleRoute.stationSearch(direction, city)) {
                    SelectionRow(title: city.title)
                }
                .buttonStyle(.plainList)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CitySearchView(direction: .from)
    }
}
