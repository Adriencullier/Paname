import Foundation

public protocol CacheManagerAccess {}
extension CacheManagerAccess {
    func getValue<Data: Codable>(for key: String) async throws -> Data? {
        guard let data: Data = try await CacheManager.shared.getValue(for: key) else {
            return nil
        }
        return data
    }

    func setValue<Data: Codable>(data: Data, for key: String) {
        Task {
            await CacheManager.shared.setValue(data: data, for: key)
        }
    }
}

private actor CacheManager {
    fileprivate static var shared = CacheManager()
    fileprivate var cachedData: [String: Data] = .init()
    
    fileprivate func getValue<Data: Codable>(for key: String) async throws -> Data? {
        guard let data = self.cachedData[key] else {
            print("⛔️ No Cached Data found for key: \(key)")
            return nil
        }
        guard let object: Data = try? JSONDecoder().decode(Data.self, from: data) else {
            print("💥 failed to decode object from data: \(data)")
            return nil
        }
        print("✅ Cached Data found")
        return object
    }
    
    fileprivate func setValue<Data: Codable>(data: Data, for key: String) {
        let data = try? JSONEncoder().encode(data)
        if let data {
            if !self.exists(key) {
                print("✅ set in cache")
                self.cachedData[key] = data
            } else {
                print("⛔️ The Key \"\(key)\" already exists")
            }
            
            
        } else {
            print("💥 failed to encode data: \(String(describing: data?.description))")
        }
    }
    
    fileprivate func exists(_ key: String) -> Bool {
        self.cachedData.keys.contains(key)
    }
}
