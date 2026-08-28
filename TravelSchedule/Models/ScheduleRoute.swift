import Foundation

enum ScheduleRoute: Hashable, Sendable {
    case citySearch(CitySearchDirection)
    case stationSearch(CitySearchDirection, City)
    case carriers
    case timeFilter
    case carrierCard(String)
}
