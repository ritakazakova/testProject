import Foundation


class FavouriteCatsViewModel: ObservableObject {
    var currentPage = 0
    var perPage = 5
    var catsListFull = false
    
    func getFavourite() {
        guard let urlPage = URL(string: "https://api.thecatapi.com/v1/favourites?page=\(currentPage)&limit=\(perPage)")  else { return }
        var request = URLRequest(url: urlPage)
        request.setValue("2949d04c-05ad-4444-8379-2dae813da1cc", forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let cats = try! JSONDecoder().decode([FavouriteImageInfo].self, from: data!)
            print(cats)
            
            self.currentPage += 1
            print(self.currentPage)
            
            if data!.count < self.perPage {
            self.catsListFull = true
                
            }
            
            DispatchQueue.main.async {
                self.favouriteCats += cats
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                print(String(decoding: jsonData, as: UTF8.self))
            } else {
                print("json data malformed")
            }
    }
        .resume()
    }
    
    @Published var favouriteCats = [FavouriteImageInfo]()
}
