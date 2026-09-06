import SwiftUI

struct CitySearchView: View {
    let direction: CitySearchDirection

    @StateObject private var viewModel = CitySearchViewModel()

    var body: some View {
        SearchListScreen(
            title: AppStrings.citySearchTitle,
            emptyMessage: AppStrings.cityNotFound,
            isEmpty: viewModel.filteredCities.isEmpty,
            query: $viewModel.query
        ) {
            ForEach(viewModel.filteredCities) { city in
                NavigationLink(value: ScheduleRoute.stationSearch(direction, city)) {
                    SelectionRow(title: city.title)
                }
                .buttonStyle(.plainList)
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        CitySearchView(direction: .from)
    }
}
