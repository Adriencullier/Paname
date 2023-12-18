import Foundation

/// Aims to define a ShipRoutes enum
protocol ShipRoutesEnumProtocol {
    /// ShipRoute of each case of enum
    var shipRoute: ShipRoute { get }
    
/// To use like this:
///     enum MyRoutes: ShipRoutesEnumProtocol {
///         case viewA
///         case viewB
///
///         var shipRoute: ShipRoute {
///             case viewA:
///                 return ShipeRoute(...)
///             case viewB:
///                 return ShipeRoute(...)
///         }
///     }
}
