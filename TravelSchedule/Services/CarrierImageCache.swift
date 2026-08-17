import UIKit

final class CarrierImageCache {
    static let shared = CarrierImageCache()

    private var images: [URL: UIImage] = [:]
    private let lock = NSLock()

    private init() {}

    func image(for url: URL) -> UIImage? {
        lock.lock()
        defer { lock.unlock() }
        return images[url]
    }

    func set(_ image: UIImage, for url: URL) {
        lock.lock()
        defer { lock.unlock() }
        images[url] = image
    }

    func image(from url: URL) async -> UIImage? {
        if let cached = image(for: url) {
            return cached
        }

        let loaded = await Task.detached(priority: .userInitiated) {
            guard let (data, response) = try? await URLSession.shared.data(from: url),
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  let image = UIImage(data: data)
            else {
                return nil as UIImage?
            }
            return image
        }.value

        if let loaded {
            set(loaded, for: url)
        }
        return loaded
    }
}
