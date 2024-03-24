import SwiftUI

public actor ViewCache<CacheData: View> {
    fileprivate var cachedData: [String: CacheData] = .init()
    
    public init() {}
    
    public func getValue(for key: String) async throws -> CacheData? {
        guard let data: CacheData = self.cachedData[key] else {
            print("~~ ViewCache ~~  No Cached Data found for key: \(key)")
            return nil
        }
        print("~~ ViewCache ~~ Cached Data found")
        return data
    }
    
    public func setValue(data: CacheData, for key: String) {
        if !self.exists(key) {
            print("~~ ViewCache ~~ set in cache")
            self.cachedData[key] = data
        } else {
            print("~~ ViewCache ~~ The Key \"\(key)\" already exists")
        }
    }
    
    fileprivate func exists(_ key: String) -> Bool {
        self.cachedData.keys.contains(key)
    }
}
