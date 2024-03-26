import Foundation

public struct WeakObserverData: Hashable {
    public static func == (lhs: WeakObserverData, rhs: WeakObserverData) -> Bool {
        return lhs.value?.id == rhs.value?.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.value?.id)
    }
    
    private(set) weak var value: (any ServiceObserver)?
}
