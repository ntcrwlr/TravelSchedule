import Foundation

enum SampleLocations {
    static let cities: [City] = [
        City(
            id: "c213",
            title: "Москва",
            stations: [
                Station(id: "s2000007", title: "Киевский вокзал"),
                Station(id: "s2000001", title: "Курский вокзал"),
                Station(id: "s2000002", title: "Ярославский вокзал"),
                Station(id: "s2000006", title: "Белорусский вокзал"),
                Station(id: "s2000009", title: "Савеловский вокзал"),
                Station(id: "s2006004", title: "Ленинградский вокзал")
            ]
        ),
        City(
            id: "c2",
            title: "Санкт Петербург",
            stations: [
                Station(id: "s9602494", title: "Московский вокзал"),
                Station(id: "s9602498", title: "Балтийский вокзал"),
                Station(id: "s9602499", title: "Ладожский вокзал"),
                Station(id: "s9602496", title: "Витебский вокзал"),
                Station(id: "s9602497", title: "Финляндский вокзал")
            ]
        ),
        City(
            id: "c239",
            title: "Сочи",
            stations: [
                Station(id: "s9613034", title: "Сочи")
            ]
        ),
        City(
            id: "c23242",
            title: "Горный воздух",
            stations: [
                Station(id: "s9613880", title: "Горный воздух")
            ]
        ),
        City(
            id: "c35",
            title: "Краснодар",
            stations: [
                Station(id: "s9613602", title: "Краснодар-1"),
                Station(id: "s9613830", title: "Краснодар-2")
            ]
        ),
        City(
            id: "c43",
            title: "Казань",
            stations: [
                Station(id: "s9623141", title: "Казань-Пассажирская")
            ]
        ),
        City(
            id: "c66",
            title: "Омск",
            stations: [
                Station(id: "s9600390", title: "Омск-Пассажирский")
            ]
        )
    ]
}
