import Foundation

public protocol ObservableService: AnyObject {
    associatedtype DataType
    
    var observers: Set<WeakObserverData> { get set }
    
    var dataKey: ObservedEvent { get }
    var data: [DataType] { get }
}

extension ObservableService {
    func addObserver<T: ServiceObserver>(_ observer: T) {
        self.observers.insert(WeakObserverData(value: observer))
    }
    
    public func updateObservers(state: ServiceDataState) {
        observers.forEach { observer in
            observer.value?.dataNeedsToBeUpdated(key: self.dataKey, state: state)
        }
    }
}
