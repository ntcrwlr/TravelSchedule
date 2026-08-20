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
        VStack(spacing: 0) {
            SearchQueryField(text: $query)

            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredCities) { city in
                            NavigationLink(value: ScheduleRoute.stationSearch(direction, city)) {
                                SelectionRow(title: city.title)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .opacity(filteredCities.isEmpty ? 0 : 1)
                .allowsHitTesting(!filteredCities.isEmpty)

                Text("Город не найден")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColor.text)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .opacity(filteredCities.isEmpty ? 1 : 0)
                    .allowsHitTesting(false)
            }
        }
        .background(AppColor.background)
        .appErrorOverlay()
        .navigationTitle("Выбор города")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(AppColor.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .tint(AppColor.text)
    }
}

#Preview {
    NavigationStack {
        CitySearchView(direction: .from)
    }
}
