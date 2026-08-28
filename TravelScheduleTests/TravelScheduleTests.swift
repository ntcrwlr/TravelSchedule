//
//  TravelScheduleTests.swift
//  TravelScheduleTests
//
//  Created by Сергей Бушков on 09.08.2026.
//

import Foundation
import Testing
@testable import TravelSchedule

struct TravelScheduleTests {
    @Test func fetchTripsFromYandexAPI() async throws {
        let trips = try await NetworkClient.shared.fetchTrips(
            from: "s2000001",
            to: "s9602497",
            date: todayString()
        )
        #expect(!trips.isEmpty)
    }

    @Test func fetchCarrierDetailsFromYandexAPI() async throws {
        let details = try await NetworkClient.shared.fetchCarrierDetails(code: "112")
        #expect(!details.title.isEmpty)
    }

    private func todayString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
