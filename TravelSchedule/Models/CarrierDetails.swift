import Foundation

struct CarrierDetails: Hashable, Sendable {
    let code: String
    let title: String
    let logoURL: URL?
    let email: String?
    let phone: String?
    let website: String?

    var emailURL: URL? {
        guard let email, !email.isEmpty else { return nil }
        return URL(string: "mailto:\(email)")
    }

    var phoneURL: URL? {
        guard let phone, !phone.isEmpty else { return nil }
        let digits = phone.filter { $0.isNumber || $0 == "+" }
        guard !digits.isEmpty else { return nil }
        return URL(string: "tel:\(digits)")
    }

    var websiteURL: URL? {
        website?.httpsURL
    }
}
