import Foundation

struct DiscoveryFilters {
    var date: Date
    var categories: [Category]
}

final class DiscoveryFiltersService: ObservableService {
    typealias DataType = DiscoveryFilters

    weak var serviceObserver: (ServiceObserver)?
    
    var data: DiscoveryFilters

    var dataKey: DataKey {
        return .discoveryFilters
    }
    
    init(date: Date = Date(), categories: [Category] = []) {
        self.data = DiscoveryFilters(date: date, categories: categories)
    }
    
    var params: [URLQueryItem] {
        var params: [URLQueryItem] = []
        if !self.data.categories.isEmpty {
            let value: String = self.data.categories
                .flatMap({ $0.tags })
                .flatMap({ $0.rawValue })
                .map({ "\'" + $0 + "\'" })
                .joined(separator: "or")
            params.append(URLQueryItem(name: "where", value: value + " in tags"))
        }
//        params.append(URLQueryItem(name: "where", value: "search(occurrences,\'%\(self.date.toString(.yearMonth))%\')"))
        return params
    }
}
