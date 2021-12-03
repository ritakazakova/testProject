import SwiftUI
import SDWebImageSwiftUI


struct CatsView: View {
    
    @ObservedObject var model = CatsViewModel()
    @GestureState var press = false
    
    var body: some View {
        NavigationView {
        
           List() {
            
            ForEach(model.cats) { cat in
                HStack {
                    
                    WebImage(url: URL(string: cat.url))
                        
                        .resizable()
                        .placeholder {
                            Text("Loading...").frame(width: CGFloat(cat.width), height: CGFloat(cat.height), alignment: .leading)
                        }
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fit)
                    
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(cat.isFavourite ? Color.yellow:Color.gray)
                        .scaleEffect(press ? 2:1)
                        .gesture(
                            LongPressGesture(minimumDuration: 0)
                                .updating($press) { currentState, gestureState, transaction in
                                    gestureState = currentState
                                }
                                .onEnded { value in
                                    let index = model.cats.firstIndex(where: { $0.id == cat.id })!
                                    model.cats[index].isFavourite.toggle()
                                    model.makeImageIsFavourite(id: cat.id)
                                }
                        )
                }
            }
            
            
            if model.catsListFull == false {
                ActivityIndicator(.constant(true), style: .medium)
                    .onAppear {
                        model.getCats()
                    }
            }
        }
        .navigationBarTitle("Cats", displayMode: .inline)
            
            
        }
    }
}


struct CatsView_Previews: PreviewProvider {
    static var previews: some View {
        CatsView()
    }
}

