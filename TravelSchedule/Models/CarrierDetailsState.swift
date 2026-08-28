import Foundation

enum CarrierDetailsState: Equatable, Sendable {
    case idle
    case loading
    case loaded(CarrierDetails)
    case failed(AppLoadError)
}
