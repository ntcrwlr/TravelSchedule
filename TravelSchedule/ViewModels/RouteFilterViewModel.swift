import Combine
import Foundation

@MainActor
final class RouteFilterViewModel: ObservableObject {
    @Published var draft: ScheduleFilters

    init(filters: ScheduleFilters) {
        draft = filters
    }

    func toggle(_ slot: DepartureTimeSlot) {
        if draft.departureTimes.contains(slot) {
            draft.departureTimes.remove(slot)
        } else {
            draft.departureTimes.insert(slot)
        }
    }

    func setShowTransfers(_ value: Bool) {
        draft.showTransfers = draft.showTransfers == value ? nil : value
    }
}
