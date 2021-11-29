import SwiftUI
import Foundation
import Combine
import SDWebImageSwiftUI


struct Cats: Codable, Identifiable {
    var id: String
    let url: String
}

class apiCall: ObservableObject {
    func getCats(completion:@escaping ([Cats]) -> ()) {
        guard let urlPage = URL(string: "https://api.thecatapi.com/v1/images/search?page=0&limit=10") else { return }
        URLSession.shared.dataTask(with: urlPage) { (data, response, error) in
            let cats = try! JSONDecoder().decode([Cats].self, from: data!)
            print(cats)
            
            
            if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                print(String(decoding: jsonData, as: UTF8.self))
            } else {
                print("json data malformed")
            }
            
            
            
            DispatchQueue.main.async {
                completion(cats)
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
            model.getCats(completion: { cats in
                self.model.cats = cats
            })
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
