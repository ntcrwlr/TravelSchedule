import SwiftUI

struct ScheduleSearchView: View {
    @State private var from: RoutePoint?
    @State private var to: RoutePoint?
    @State private var path = NavigationPath()
    @StateObject private var carriersViewModel = CarriersListViewModel()

    private var canFind: Bool {
        from != nil && to != nil
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading, spacing: 16) {
                searchCard
                    .padding(.horizontal, 16)

                if canFind {
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
                        let point = RoutePoint(
                            id: station.id,
                            title: "\(city.title) (\(station.title))"
                        )
                        switch direction {
                        case .from:
                            from = point
                        case .to:
                            to = point
                        }
                        path.removeLast(min(2, path.count))
                    }
                case .carriers:
                    CarriersListView(viewModel: carriersViewModel, path: $path)
                case .timeFilter:
                    RouteFilterView(filters: carriersViewModel.filters) { applied in
                        carriersViewModel.filters = applied
                    }
                case .carrierCard:
                    CarrierDetailsView()
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: canFind)
    }

    private var searchCard: some View {
        HStack(spacing: 16) {
            VStack(spacing: 0) {
                stationRow(point: from, placeholder: "Откуда") {
                    path.append(ScheduleRoute.citySearch(.from))
                }

                Rectangle()
                    .fill(AppColor.lightGray)
                    .frame(height: 1)
                    .padding(.horizontal, 16)

                stationRow(point: to, placeholder: "Куда") {
                    path.append(ScheduleRoute.citySearch(.to))
                }
            }
            .background(AppColor.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            Button(action: swapStations) {
                Image(systemName: "arrow.2.circlepath")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(AppColor.blue)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(AppColor.white))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Поменять местами")
        }
        .padding(16)
        .background(AppColor.blue)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var findButton: some View {
        Button {
            carriersViewModel.configure(from: from, to: to)
            path.append(ScheduleRoute.carriers)
        } label: {
            Text("Найти")
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

    private func swapStations() {
        let currentFrom = from
        from = to
        to = currentFrom
    }
}

#Preview("Пустые поля") {
    ScheduleSearchView()
}

#Preview("Тёмная тема") {
    ScheduleSearchView()
        .preferredColorScheme(.dark)
}
