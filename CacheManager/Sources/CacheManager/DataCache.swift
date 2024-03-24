import Foundation

public actor DataCache<CacheData: Codable> {
    fileprivate var cachedData: [String: Data] = .init()
    
    public init() {}
    
    public func getValue(for key: String) async throws -> CacheData? {
        guard let data: Data = self.cachedData[key] else {
            print("~~ DataCache ~~ No Cached Data found for key: \(key)")
            return nil
        }
        guard let object: CacheData = try? JSONDecoder().decode(CacheData.self, from: data) else {
            print("~~ DataCache ~~ 💥 failed to decode object from data: \(data)")
            return nil
        }
        print("~~ DataCache ~~ Cached Data found")
        return object
    }
    
    public func setValue(data: CacheData, for key: String) {
        let data = try? JSONEncoder().encode(data)
        if let data {
            if !self.exists(key) {
                print("~~ DataCache ~~ set in cache")
                self.cachedData[key] = data
            } else {
                print("~~ DataCache ~~ The Key \"\(key)\" already exists")
            }
        } else {
            print("~~ DataCache ~~ 💥 failed to encode data: \(String(describing: data?.description))")
        }
    }
    
    fileprivate func exists(_ key: String) -> Bool {
        self.cachedData.keys.contains(key)
    }
}
