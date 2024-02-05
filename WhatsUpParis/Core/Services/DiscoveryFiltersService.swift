import Foundation

struct DiscoveryFilters {
    var date: Date?
    var categories: [Category]
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
    
    init(date: Date? = nil, categories: [Category] = []) {
        self.data = DiscoveryFilters(date: date, categories: categories)
        self.updateObservers(state: .successed)
    }
}
