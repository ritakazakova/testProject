import Foundation


class CatsViewModel: ObservableObject {
    
    var currentPage = 0
    var perPage = 5
    var catsListFull = false
    
    @Published var cats = [Cats]()
    
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
    
    
    func makeImageIsFavourite(id: String) {
        
        let json: [String: Any] = ["image_id": "\(id)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "https://api.thecatapi.com/v1/favourites")!
        var request = URLRequest(url: url)
        request.setValue("2949d04c-05ad-4444-8379-2dae813da1cc", forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
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
}
