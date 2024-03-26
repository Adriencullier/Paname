import Foundation
import HTTPAgent
import CacheManager

/// Aims to give access to getImageData logic
/// Use data from cache if exists else, loads it and stores it into cache
public protocol DataImageAccess {
    /// Image cache
    var imageCache: DataCache<Data> { get }
}

/// Public extension with getImageData function
public extension DataImageAccess {
    /// Aims get image from cache if exists else load it
    /// - Parameters:
    ///   - urlStr: url str of the image
    ///   - completion: image data
    func getImageData(from urlStr: String, completion: @escaping (Data) -> Void) {
        Task {
            guard let data = try await self.imageCache.getValue(for: urlStr) else {
                self.loadImage(urlStr: urlStr) { data in
                    Task {
                        await self.imageCache.setValue(data: data, for: urlStr)
                    }
                    completion(data)
                }
                return
            }
            completion(data)
        }
    }
}

/// Fileprivate extension with loadImage function
fileprivate extension DataImageAccess {
    func loadImage(urlStr: String, completion: @escaping (Data) -> Void) {
        Task {
            let result: Result<Data, HTTPError> = await HTTPAgent.loadImageData(from: urlStr)
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
