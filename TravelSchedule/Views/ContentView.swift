//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Сергей Бушков on 09.08.2026.
//

import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    @State private var testTask: Task<Void, Never>?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Запустить тесты API") {
                runTests()
            }
        }
        .padding()
        .onDisappear {
            testTask?.cancel()
            testTask = nil
        }
    }

    private func runTests() {
        testTask?.cancel()
        testTask = Task {
            do {
                try await testAllServices()
            } catch is CancellationError {
                print("API tests cancelled")
            } catch {
                print("Error during API tests: \(error)")
            }
        }
    }
}

func testAllServices() async throws {
    let networkClient = NetworkClient.shared

    try await testFetchNearestStations(networkClient)
    try Task.checkCancellation()
    try await testFetchStationsList(networkClient)
    try Task.checkCancellation()
    try await testFetchScheduleBetweenStations(networkClient)
    try Task.checkCancellation()
    try await testFetchScheduleOnStation(networkClient)
    try Task.checkCancellation()
    try await testFetchThread(networkClient)
    try Task.checkCancellation()
    try await testFetchCarrier(networkClient)
    try Task.checkCancellation()
    try await testFetchCopyright(networkClient)
    try Task.checkCancellation()
    try await testFetchNearestSettlement(networkClient)
}

func testFetchNearestStations(_ networkClient: NetworkClient) async throws {
    print("Fetching nearest stations...")
    let stations = try await networkClient.getNearestStations(
        lat: 59.864177,
        lng: 30.319163,
        distance: 50
    )
    print("Successfully fetched nearest stations: \(stations)")
}

func testFetchStationsList(_ networkClient: NetworkClient) async throws {
    print("Fetching stations list...")
    let stationsList = try await networkClient.getStationsList()
    print("Successfully fetched stations list, countries count: \(stationsList.countries?.count ?? 0)")
}

func testFetchScheduleBetweenStations(_ networkClient: NetworkClient) async throws {
    print("Fetching schedule between stations...")
    let schedule = try await networkClient.getScheduleBetweenStations(
        from: "c146",
        to: "c213",
        date: nil,
        transfers: nil
    )
    print("Successfully fetched schedule between stations: \(schedule)")
}

func testFetchScheduleOnStation(_ networkClient: NetworkClient) async throws {
    print("Fetching schedule on station...")
    let schedule = try await networkClient.getScheduleOnStation(station: "s9600213")
    print("Successfully fetched schedule on station: \(schedule)")
}

func testFetchThread(_ networkClient: NetworkClient) async throws {
    print("Fetching thread...")
    let thread = try await networkClient.getThread(uid: "038AA_tis")
    print("Successfully fetched thread: \(thread)")
}

func testFetchCarrier(_ networkClient: NetworkClient) async throws {
    print("Fetching carrier...")
    let carrier = try await networkClient.getCarrier(code: "680")
    print("Successfully fetched carrier: \(carrier)")
}

func testFetchCopyright(_ networkClient: NetworkClient) async throws {
    print("Fetching copyright...")
    let copyright = try await networkClient.getCopyright()
    print("Successfully fetched copyright: \(copyright)")
}

func testFetchNearestSettlement(_ networkClient: NetworkClient) async throws {
    print("Fetching nearest settlement...")
    let settlement = try await networkClient.getNearestSettlement(
        lat: 50.440046,
        lng: 40.4882367
    )
    print("Successfully fetched nearest settlement: \(settlement)")
}

#Preview {
    ContentView()
}
