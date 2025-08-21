import Combine
import ComposableArchitecture
import MapKit

extension LocalSearchClient {
  public static let live = LocalSearchClient(
    search: { request in
      .run { send in
        let result = await withCheckedContinuation { continuation in
          MKLocalSearch(request: request).start { response, error in
            switch (response, error) {
            case let (.some(response), _):
              continuation.resume(returning: Result<LocalSearchResponse, LocalSearchClient.Error>.success(LocalSearchResponse(response: response)))

            case (_, .some):
              continuation.resume(returning: Result<LocalSearchResponse, LocalSearchClient.Error>.failure(LocalSearchClient.Error()))

            case (.none, .none):
              continuation.resume(returning: Result<LocalSearchResponse, LocalSearchClient.Error>.failure(LocalSearchClient.Error()))
            }
          }
        }
        await send(result)
      }
    })
}
