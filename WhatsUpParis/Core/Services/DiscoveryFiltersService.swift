import Foundation

struct DiscoveryFilters {
    var date: Date?
    var categories: [Category]
    var audiences: [Audience]
}

final class DiscoveryFiltersService: ObservableService {
    var observers: Set<Weak<ServiceObserver>>  = []
        
    typealias DataType = DiscoveryFilters
    
    var data: DiscoveryFilters {
        didSet {
            self.updateObservers(state: .successed)
        }
    }

    var dataKey: DataKey {
        return .discoveryFilters
    }
    
    init(date: Date? = nil, 
         categories: [Category] = [],
         audiences: [Audience] = []) {
        self.data = DiscoveryFilters(date: date,
                                     categories: categories,
                                     audiences: audiences)
        self.updateObservers(state: .successed)
    }
}
