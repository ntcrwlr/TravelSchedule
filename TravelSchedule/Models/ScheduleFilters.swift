import Foundation

enum DepartureTimeSlot: String, CaseIterable, Hashable {
    case morning
    case day
    case evening
    case night

    var title: String {
        switch self {
        case .morning:
            return AppStrings.morningSlot
        case .day:
            return AppStrings.daySlot
        case .evening:
            return AppStrings.eveningSlot
        case .night:
            return AppStrings.nightSlot
        }
    }

    func contains(hour: Int) -> Bool {
        switch self {
        case .morning:
            return (6..<12).contains(hour)
        case .day:
            return (12..<18).contains(hour)
        case .evening:
            return (18..<24).contains(hour)
        case .night:
            return (0..<6).contains(hour)
        }
    }
}

struct ScheduleFilters: Equatable {
    var departureTimes: Set<DepartureTimeSlot> = []
    var showTransfers: Bool?

    var isActive: Bool {
        !departureTimes.isEmpty || showTransfers != nil
    }

    func matches(_ trip: Trip) -> Bool {
        if !departureTimes.isEmpty {
            let matchesTime = departureTimes.contains { $0.contains(hour: trip.departureHour) }
            guard matchesTime else { return false }
        }

        if let showTransfers {
            return trip.hasTransfers == showTransfers
        }

        return true
    }
}
