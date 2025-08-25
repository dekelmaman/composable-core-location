import ComposableArchitecture
import MapKit

public struct LocalSearchClient {
  public var search: (MKLocalSearch.Request) -> Effect<Result<LocalSearchResponse, LocalSearchClient.Error>>

  public init(
    search: @escaping (MKLocalSearch.Request) -> Effect<Result<LocalSearchResponse, LocalSearchClient.Error>>
  ) {
    self.search = search
  }

  public struct Error: Swift.Error, Equatable {
    public init() {}
  }
}

// MARK: - Dependency

private enum LocalSearchClientKey: DependencyKey {
  static let liveValue: LocalSearchClient = LocalSearchClient.live
}

extension DependencyValues {
  public var localSearch: LocalSearchClient {
    get { self[LocalSearchClientKey.self] }
    set { self[LocalSearchClientKey.self] = newValue }
  }
}
