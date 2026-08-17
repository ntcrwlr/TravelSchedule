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
    let client = Client(
        serverURL: try Servers.Server1.url(),
        transport: URLSessionTransport()
    )
    let apikey = ApiKey.yandexRasp

    try await testFetchNearestStations(client: client, apikey: apikey)
    try Task.checkCancellation()
    try await testFetchStationsList(client: client, apikey: apikey)
    try Task.checkCancellation()
    try await testFetchScheduleBetweenStations(client: client, apikey: apikey)
    try Task.checkCancellation()
    try await testFetchScheduleOnStation(client: client, apikey: apikey)
    try Task.checkCancellation()
    try await testFetchThread(client: client, apikey: apikey)
    try Task.checkCancellation()
    try await testFetchCarrier(client: client, apikey: apikey)
    try Task.checkCancellation()
    try await testFetchCopyright(client: client, apikey: apikey)
    try Task.checkCancellation()
    try await testFetchNearestSettlement(client: client, apikey: apikey)
}

func testFetchNearestStations(client: Client, apikey: String) async throws {
    let service = NearestStationsService(client: client, apikey: apikey)
    print("Fetching nearest stations...")
    let stations = try await service.getNearestStations(
        lat: 59.864177,
        lng: 30.319163,
        distance: 50
    )
    print("Successfully fetched nearest stations: \(stations)")
}

func testFetchStationsList(client: Client, apikey: String) async throws {
    let service = StationsListService(client: client, apikey: apikey)
    print("Fetching stations list...")
    let stationsList = try await service.getStationsList()
    print("Successfully fetched stations list, countries count: \(stationsList.countries?.count ?? 0)")
}

func testFetchScheduleBetweenStations(client: Client, apikey: String) async throws {
    let service = ScheduleBetweenStationsService(client: client, apikey: apikey)
    print("Fetching schedule between stations...")
    let schedule = try await service.getScheduleBetweenStations(
        from: "c146",
        to: "c213"
    )
    print("Successfully fetched schedule between stations: \(schedule)")
}

func testFetchScheduleOnStation(client: Client, apikey: String) async throws {
    let service = ScheduleOnStationService(client: client, apikey: apikey)
    print("Fetching schedule on station...")
    let schedule = try await service.getScheduleOnStation(station: "s9600213")
    print("Successfully fetched schedule on station: \(schedule)")
}

func testFetchThread(client: Client, apikey: String) async throws {
    let service = ThreadService(client: client, apikey: apikey)
    print("Fetching thread...")
    let thread = try await service.getThread(uid: "038AA_tis")
    print("Successfully fetched thread: \(thread)")
}

func testFetchCarrier(client: Client, apikey: String) async throws {
    let service = CarrierService(client: client, apikey: apikey)
    print("Fetching carrier...")
    let carrier = try await service.getCarrier(code: "680")
    print("Successfully fetched carrier: \(carrier)")
}

func testFetchCopyright(client: Client, apikey: String) async throws {
    let service = CopyrightService(client: client, apikey: apikey)
    print("Fetching copyright...")
    let copyright = try await service.getCopyright()
    print("Successfully fetched copyright: \(copyright)")
}

func testFetchNearestSettlement(client: Client, apikey: String) async throws {
    let service = NearestSettlementService(client: client, apikey: apikey)
    print("Fetching nearest settlement...")
    let settlement = try await service.getNearestSettlement(
        lat: 50.440046,
        lng: 40.4882367
    )
    print("Successfully fetched nearest settlement: \(settlement)")
}

#Preview {
    ContentView()
}
