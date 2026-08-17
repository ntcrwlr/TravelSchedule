import Foundation

struct RaspSearchDTO: Decodable {
    let segments: [RaspSegmentDTO]?
}

struct RaspSegmentDTO: Decodable {
    let departure: String?
    let arrival: String?
    let duration: Double?
    let hasTransfers: Bool?
    let thread: RaspThreadDTO?
    let transfers: [RaspPointDTO]?
    let details: [RaspDetailDTO]?

    enum CodingKeys: String, CodingKey {
        case departure
        case arrival
        case duration
        case hasTransfers = "has_transfers"
        case thread
        case transfers
        case details
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        departure = try container.decodeIfPresent(String.self, forKey: .departure)
        arrival = try container.decodeIfPresent(String.self, forKey: .arrival)
        hasTransfers = try container.decodeIfPresent(Bool.self, forKey: .hasTransfers)
        thread = try container.decodeIfPresent(RaspThreadDTO.self, forKey: .thread)
        transfers = try container.decodeIfPresent([RaspPointDTO].self, forKey: .transfers)
        details = try? container.decode([RaspDetailDTO].self, forKey: .details)

        if let value = try? container.decode(Double.self, forKey: .duration) {
            duration = value
        } else if let value = try? container.decode(Int.self, forKey: .duration) {
            duration = Double(value)
        } else {
            duration = nil
        }
    }
}

struct RaspDetailDTO: Decodable {
    let thread: RaspThreadDTO?
    let duration: Double?
    let isTransfer: Bool?
    let transferPoint: RaspPointDTO?

    enum CodingKeys: String, CodingKey {
        case thread
        case duration
        case isTransfer = "is_transfer"
        case transferPoint = "transfer_point"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        thread = try container.decodeIfPresent(RaspThreadDTO.self, forKey: .thread)
        isTransfer = try container.decodeIfPresent(Bool.self, forKey: .isTransfer)
        transferPoint = try container.decodeIfPresent(RaspPointDTO.self, forKey: .transferPoint)
        if let value = try? container.decode(Double.self, forKey: .duration) {
            duration = value
        } else if let value = try? container.decode(Int.self, forKey: .duration) {
            duration = Double(value)
        } else {
            duration = nil
        }
    }
}

struct RaspThreadDTO: Decodable {
    let uid: String?
    let carrier: RaspCarrierDTO?
}

struct RaspCarrierDTO: Decodable {
    let title: String?
    let logo: String?
    let logoSVG: String?
    let code: String?

    enum CodingKeys: String, CodingKey {
        case title
        case logo
        case logoSVG = "logo_svg"
        case code
    }

    var logoPath: String? {
        if let logo, !logo.isEmpty { return logo }
        if let logoSVG, !logoSVG.isEmpty { return logoSVG }
        return nil
    }

    var rasterLogoPath: String? {
        guard let logo, !logo.isEmpty, !logo.lowercased().hasSuffix(".svg") else {
            return nil
        }
        return logo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        logo = try container.decodeIfPresent(String.self, forKey: .logo)
        logoSVG = try container.decodeIfPresent(String.self, forKey: .logoSVG)
        if let intCode = try? container.decode(Int.self, forKey: .code) {
            code = String(intCode)
        } else {
            code = try container.decodeIfPresent(String.self, forKey: .code)
        }
    }
}

struct RaspPointDTO: Decodable {
    let title: String?
}

struct RaspCarrierEnvelope: Decodable {
    let carrier: RaspCarrierDTO?
}
