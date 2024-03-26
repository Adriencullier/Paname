import HTTPAgent
import Paname_Core

/// EventsService
public final class EventsService: ObservableService {
    // MARK: - Typealias
    public typealias DataType = EventEntity
    
    // MARK: - Properties
    public var observers: Set<WeakObserverData> = []
    public var dataKey: ObservedEvent = .discoveryEvent
    public var data: [EventEntity] = []
    
    // MARK: - internal functions
    func fetchData() {
        Task {
            let result: Result<[EventEntity], HTTPError> = await HTTPAgent.request(endpoint: DiscoveryEndpoint.allEvents)
            switch result {
            case .success(let eventsResult):
                self.data = eventsResult
                self.updateObservers(state: .successed)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
