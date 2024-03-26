import Foundation

public enum ServiceDataState {
    case successed
    case failed(error: Error)
    case loading
    case none
}
