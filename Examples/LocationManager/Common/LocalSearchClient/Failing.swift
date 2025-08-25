import ComposableArchitecture
import MapKit
import XCTestDynamicOverlay

extension LocalSearchClient {
  public static let failing = Self(
    search: { _ in
      Effect<Result<LocalSearchResponse, LocalSearchClient.Error>>.run { _ in
        unimplemented("LocalSearchClient.search")
      }
    }
  )
}
