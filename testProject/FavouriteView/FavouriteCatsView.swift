import SwiftUI
import SDWebImageSwiftUI


struct FavouriteCatsView: View {
    @ObservedObject var model = FavouriteCatsViewModel()
    var body: some View {
        NavigationView {
            List() {
                
                ForEach(model.favouriteCats) { cat in
                    HStack {
                                                
                        WebImage(url: URL(string: cat.image.url))
                            
                            .resizable()
                            .placeholder {
                                Text("Loading...")
                            }
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                    }
                }
                
                
                if model.catsListFull == false {
                    ActivityIndicator(.constant(true), style: .medium)
                        .onAppear {
                            model.getFavourite()
                        }
                }
            }
                .navigationBarTitle("Favourite cats", displayMode: .inline)
        }
    }
}

struct FavouriteCatsView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteCatsView()
    }
}
