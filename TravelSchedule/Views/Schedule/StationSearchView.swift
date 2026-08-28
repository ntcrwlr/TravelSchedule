import SwiftUI

struct StationSearchView: View {
    let onSelect: (Station) -> Void

    @StateObject private var viewModel: StationSearchViewModel

    init(city: City, onSelect: @escaping (Station) -> Void) {
        self.onSelect = onSelect
        _viewModel = StateObject(wrappedValue: StationSearchViewModel(city: city))
    }

    var body: some View {
        SearchListScreen(
            title: AppStrings.stationSearchTitle,
            emptyMessage: AppStrings.stationNotFound,
            isEmpty: viewModel.filteredStations.isEmpty,
            query: $viewModel.query
        ) {
            ForEach(viewModel.filteredStations) { station in
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
