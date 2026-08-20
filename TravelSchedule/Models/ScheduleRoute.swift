import Foundation

enum ScheduleRoute: Hashable {
    case citySearch(CitySearchDirection)
    case stationSearch(CitySearchDirection, City)
    case carriers
    case timeFilter
    case carrierCard
}
