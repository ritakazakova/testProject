import Foundation


struct Cats: Codable, Identifiable {
    var id: String
    let url: String
    var width: Int
    var height: Int
    var isFavourite: Bool = false
}

extension Cats {
    enum CodingKeys: CodingKey {
        case id, url, width, height
    }
}
