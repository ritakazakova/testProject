import SwiftUI
import Foundation
import Combine
import SDWebImageSwiftUI


struct Cats: Codable, Identifiable {
    var id: String
    let url: String
    var width: Int
    var height: Int
}

class apiCall: ObservableObject {
    
    var currentPage = 0
    var perPage = 5
    var catsListFull = false
    var isFavourite: Bool = true
    
    func getCats() {
        
        
        guard let urlPage = URL(string: "https://api.thecatapi.com/v1/images/search?page=\(currentPage)&limit=\(perPage)")  else { return }
        URLSession.shared.dataTask(with: urlPage) { (data, response, error) in
            let cats = try! JSONDecoder().decode([Cats].self, from: data!)
            print(cats)
            
            self.currentPage += 1
            print(self.currentPage)
            
            if data!.count < self.perPage {
            self.catsListFull = true
            
           }
            
            if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                print(String(decoding: jsonData, as: UTF8.self))
            } else {
                print("json data malformed")
            }
            
            
            
            DispatchQueue.main.async {
                self.cats += cats
                
            }
        }
        .resume()
        
    }
    @Published var cats = [Cats]()
    
}

struct ContentView: View {
    
    @ObservedObject var model = apiCall()
    @GestureState var press = false
    @State var show = false
    
    
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

                    if model.isFavourite {
                        Image(systemName: "star.fill")
                            .foregroundColor(show ? Color.yellow:Color.gray)
                            .scaleEffect(press ? 2:1)
                            .gesture(
                                LongPressGesture(minimumDuration: 0)
                                    .updating($press) { currentState, gestureState, transaction in
                                        gestureState = currentState
                                    }
                                    .onEnded { value in
                                        show.toggle()
                                    }
                            )
                    }
                }            }
            
            
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

