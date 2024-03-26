import Foundation

public protocol ServiceObserver: AnyObject, Identifiable {
    func dataNeedsToBeUpdated(key: ObservedEvent, state: ServiceDataState)
}

extension ServiceObserver {
    var id: UUID {
        return UUID()
    }

    public func observeServices(_ services: [any ObservableService]) {
        services.forEach({ $0.addObserver(self) })
    }
}
