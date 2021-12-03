import SwiftUI

@main
struct testProjectApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                CatsView()
                    .tabItem {
                        Label("Cats", systemImage: "photo")
                    }
                FavouriteCatsView()
                    .tabItem {
                        Label("Favourite", systemImage: "star.fill")
                    }
            }
        }
    }
}
