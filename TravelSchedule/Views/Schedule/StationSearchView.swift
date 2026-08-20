import SwiftUI

struct StationSearchView: View {
    let city: City
    let onSelect: (Station) -> Void

    @State private var query = ""

    private var filteredStations: [Station] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return city.stations }
        return city.stations.filter { $0.title.localizedCaseInsensitiveContains(trimmed) }
    }

    var body: some View {
        SearchListScreen(
            title: AppStrings.stationSearchTitle,
            emptyMessage: AppStrings.stationNotFound,
            isEmpty: filteredStations.isEmpty,
            query: $query
        ) {
            ForEach(filteredStations) { station in
                Button {
                    onSelect(station)
                } label: {
                    SelectionRow(title: station.title)
                }
                .buttonStyle(.plainList)
            }
        }
    }
}

#Preview {
    NavigationStack {
        StationSearchView(
            city: SampleLocations.cities[0]
        ) { _ in }
    }
}
