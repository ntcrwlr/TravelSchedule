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
        VStack(spacing: 0) {
            SearchQueryField(text: $query)

            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredStations) { station in
                            Button {
                                onSelect(station)
                            } label: {
                                SelectionRow(title: station.title)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .opacity(filteredStations.isEmpty ? 0 : 1)
                .allowsHitTesting(!filteredStations.isEmpty)

                Text("Станция не найдена")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColor.text)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .opacity(filteredStations.isEmpty ? 1 : 0)
                    .allowsHitTesting(false)
            }
        }
        .background(AppColor.background)
        .appErrorOverlay()
        .navigationTitle("Выбор станции")
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
        StationSearchView(
            city: SampleLocations.cities[0]
        ) { _ in }
    }
}
