import SwiftUI
import Foundation
import Combine
import SDWebImageSwiftUI


struct Cats: Codable, Identifiable {
    var id: String
    let url: String
}

class apiCall: ObservableObject {
    
    var currentPage = 0
    let perPage = 3
    var catsListFull = false
    
    func getCats() {
        guard let urlPage = URL(string: "https://api.thecatapi.com/v1/images/search?page=\(currentPage)&limit=\(perPage)") else { return }
        URLSession.shared.dataTask(with: urlPage) { (data, response, error) in
            let cats = try! JSONDecoder().decode([Cats].self, from: data!)
            print(cats)
            
            self.currentPage += 1
            
            if data!.count < self.perPage {
                self.catsListFull = true
            }
            
//            if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers),
//               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
//                print(String(decoding: jsonData, as: UTF8.self))
//            } else {
//                print("json data malformed")
//            }
            
            
            
            DispatchQueue.main.async {
                self.cats = cats
                
            }
        }
        .resume()
        
    }
    
    
    @Published var cats = [Cats]()
}

struct ContentView: View {
    
    @ObservedObject var model = apiCall()
    
    var body: some View {
        
        List(model.cats) { cat in
            
            WebImage(url: URL(string: cat.url))
                .resizable()
                .placeholder {
                    Text("Loading...")
                        
                }
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
        }
        .onAppear() {
            model.getCats()
        }
        
        if model.catsListFull == false {
            ActivityIndicator(.constant(false), style: .large)
                .onAppear {
                    model.getCats()
                }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
