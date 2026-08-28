import UIKit

actor CarrierImageCache {
    static let shared = CarrierImageCache()

    private var imageData: [URL: Data] = [:]

    func cachedImage(for url: URL) -> UIImage? {
        guard let data = imageData[url] else { return nil }
        return UIImage(data: data)
    }

    func loadImage(from url: URL) async -> UIImage? {
        if let cached = cachedImage(for: url) {
            return cached
        }

        guard let data = try? await NetworkClient.shared.downloadData(from: url),
              let image = UIImage(data: data)
        else {
            return nil
        }

        imageData[url] = data
        return image
    }
}
