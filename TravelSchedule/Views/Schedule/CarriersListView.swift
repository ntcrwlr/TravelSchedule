import SwiftUI

struct CarriersListView: View {
    @ObservedObject var viewModel: CarriersListViewModel
    @Binding var path: NavigationPath

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.routeTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(AppColor.text)
                    .padding(.horizontal, 16)

                content
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            refineButton
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .hiddenWhen(viewModel.isLoading)
                .disabled(viewModel.isLoading)
        }
        .background(AppColor.background)
        .appErrorOverlay()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(AppColor.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .tint(AppColor.text)
        .task {
            await viewModel.load()
        }
    }

    private var content: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.filteredTrips) { trip in
                        Button {
                            if let code = trip.carrierCode {
                                path.append(ScheduleRoute.carrierCard(code))
                            }
                        } label: {
                            CarrierCardView(trip: trip)
                        }
                        .buttonStyle(.plain)
                        .disabled(trip.carrierCode == nil)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 88)
            }
            .hiddenWhen(isEmptyState || viewModel.isLoading)
            .allowsHitTesting(!isEmptyState && !viewModel.isLoading)

            ProgressView()
                .hiddenWhen(!viewModel.isLoading)

            Text(AppStrings.noVariants)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(AppColor.text)
                .hiddenWhen(!isEmptyState)
                .allowsHitTesting(false)
        }
    }

    private var isEmptyState: Bool {
        !viewModel.isLoading && viewModel.loadError == nil && viewModel.filteredTrips.isEmpty
    }

    private var refineButton: some View {
        Button {
            path.append(ScheduleRoute.timeFilter)
        } label: {
            HStack(spacing: 4) {
                Text(AppStrings.refineTime)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AppColor.white)
                Circle()
                    .fill(AppColor.red)
                    .frame(width: 8, height: 8)
                    .hiddenWhen(!viewModel.filters.isActive)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(AppColor.blue)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        CarriersListView(
            viewModel: CarriersListViewModel(
                from: RoutePoint(id: "s2000001", title: "Москва (Ярославский вокзал)"),
                to: RoutePoint(id: "s9602497", title: "Санкт Петербург (Балтийский вокзал)")
            ),
            path: .constant(NavigationPath())
        )
    }
}
