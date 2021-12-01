import SwiftUI

struct FavouriteCatsView: View {
    var body: some View {
        NavigationView {
            Text("Hello, World!")
                .navigationBarTitle("Favourite cats", displayMode: .inline)
        }
    }
}

struct FavouriteCatsView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteCatsView()
    }
}
