import Combine
import ComposableArchitecture
import ComposableCoreLocation
import MapKit
import SwiftUI

struct LocationManagerView: View {
  @Environment(\.colorScheme) var colorScheme
  @Perception.Bindable var store: Store<AppState, AppAction>

  var body: some View {
    WithPerceptionTracking {
      ZStack {
        MapView(
          pointsOfInterest: store.pointsOfInterest,
          region: Binding(
            get: { store.region },
            set: { store.send(.updateRegion($0)) }
          )
        )
        .edgesIgnoringSafeArea([.all])

        VStack(alignment: .center) {
          Spacer()

          HStack(spacing: 16) {
            ForEach(AppState.pointOfInterestCategories, id: \.rawValue) { category in
              WithPerceptionTracking {
                Button(category.displayName) { store.send(.categoryButtonTapped(category)) }
                  .buttonStyle(PlainButtonStyle())
                  .padding([.all], 12)
                  .background(
                    category == store.pointOfInterestCategory ? Color.blue : Color.secondary
                  )
                  .foregroundColor(.white)
                  .cornerRadius(8)
              }
            }

            Spacer()

            Button(action: { store.send(.currentLocationButtonTapped) }) {
              Text("📍")
                .font(.body)
                .foregroundColor(Color.white)
                .frame(width: 44, height: 44)
                .background(Color.secondary)
                .clipShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())

          }
          .padding([.leading, .trailing])
          .padding([.bottom], 16)
        }
      }
      .alert(
        item: Binding(
          get: { store.alert },
          set: { _ in store.send(.dismissAlertButtonTapped) }
        )
      ) { alert in
        Alert(title: Text(alert.title))
      }
      .onAppear { store.send(.onAppear) }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let appView = LocationManagerView(
      store: Store(initialState: AppState()) {
        AppReducer()
      }
    )

    return Group {
      appView
      appView
        .environment(\.colorScheme, .dark)
    }
  }
}
