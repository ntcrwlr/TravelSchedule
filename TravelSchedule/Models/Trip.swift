import Foundation

struct Trip: Identifiable, Hashable, Sendable {
    let id: String
    let carrierName: String
    let carrierCode: String?
    var logoURL: URL?
    let dateText: String
    let departureTime: String
    let arrivalTime: String
    let durationText: String
    let transferText: String?
    let departureHour: Int
    let hasTransfers: Bool
}

extension Trip {
    init?(segment: Components.Schemas.Segment) {
        self.init(
            departure: segment.departure,
            arrival: segment.arrival,
            duration: segment.duration,
            hasTransfers: segment.has_transfers,
            threadUID: segment.thread?.uid,
            carrierTitle: segment.thread?.carrier?.title,
            carrierCode: segment.thread?.carrier?.code.map(String.init),
            carrierLogo: segment.thread?.carrier?.logo,
            transferTitle: nil
        )
    }

    init?(segment: RaspSegmentDTO) {
        let thread = segment.thread ?? segment.details?.first(where: { $0.thread != nil })?.thread
        let duration = segment.duration
            ?? segment.details?.compactMap(\.duration).reduce(0, +)
        let transferTitle = segment.transfers?.first?.title
            ?? segment.details?.first(where: { $0.isTransfer == true })?.transferPoint?.title

        self.init(
            departure: segment.departure,
            arrival: segment.arrival,
            duration: duration,
            hasTransfers: segment.hasTransfers,
            threadUID: thread?.uid,
            carrierTitle: thread?.carrier?.title,
            carrierCode: thread?.carrier?.code,
            carrierLogo: thread?.carrier?.rasterLogoPath,
            transferTitle: transferTitle
        )
    }

    private init?(
        departure: String?,
        arrival: String?,
        duration: Double?,
        hasTransfers: Bool?,
        threadUID: String?,
        carrierTitle: String?,
        carrierCode: String?,
        carrierLogo: String?,
        transferTitle: String?
    ) {
        guard
            let departureString = departure,
            let arrivalString = arrival,
            let departureDate = Self.parseDate(departureString),
            let arrivalDate = Self.parseDate(arrivalString)
        else {
            return nil
        }

        id = (threadUID ?? UUID().uuidString) + departureString
        carrierName = carrierTitle ?? AppStrings.carrierFallback
        self.carrierCode = carrierCode
        logoURL = carrierLogo?.httpsURL
        dateText = Self.dateText(from: departureDate)
        departureTime = Self.timeText(from: departureDate)
        arrivalTime = Self.timeText(from: arrivalDate)
        durationText = Self.durationText(seconds: duration)
        self.hasTransfers = hasTransfers ?? (transferTitle != nil)
        if self.hasTransfers {
            if let transferTitle, !transferTitle.isEmpty {
                transferText = AppStrings.transferPrefix + transferTitle
            } else {
                transferText = AppStrings.transferFallback
            }
        } else {
            transferText = nil
        }
        departureHour = Calendar.current.component(.hour, from: departureDate)
    }

    func withLogoURL(_ url: URL) -> Trip {
        var copy = self
        copy.logoURL = url
        return copy
    }

    private static func parseDate(_ string: String) -> Date? {
        let withFractional = ISO8601DateFormatter()
        withFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = withFractional.date(from: string) {
            return date
        }

        let standard = ISO8601DateFormatter()
        standard.formatOptions = [.withInternetDateTime]
        return standard.date(from: string)
    }

    private static func dateText(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
    }

    private static func timeText(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private static func durationText(seconds: Double?) -> String {
        let total = Int(seconds ?? 0)
        let hours = total / 3600
        let minutes = (total % 3600) / 60

        if hours > 0 && minutes > 0 {
            return "\(hours) \(hoursWord(hours)) \(minutes) \(minutesWord(minutes))"
        }
        if hours > 0 {
            return "\(hours) \(hoursWord(hours))"
        }
        return "\(max(minutes, 1)) \(minutesWord(max(minutes, 1)))"
    }

    private static func hoursWord(_ value: Int) -> String {
        let mod10 = value % 10
        let mod100 = value % 100
        if mod10 == 1 && mod100 != 11 { return "час" }
        if (2...4).contains(mod10) && !(12...14).contains(mod100) { return "часа" }
        return "часов"
    }

    private static func minutesWord(_ value: Int) -> String {
        let mod10 = value % 10
        let mod100 = value % 100
        if mod10 == 1 && mod100 != 11 { return "минута" }
        if (2...4).contains(mod10) && !(12...14).contains(mod100) { return "минуты" }
        return "минут"
    }
}

extension String {
    var httpsURL: URL? {
        if hasPrefix("https://") || hasPrefix("http://") {
            return URL(string: self)
        }
        if hasPrefix("//") {
            return URL(string: "https:" + self)
        }
        return URL(string: "https://" + self)
    }
}
