import Foundation

struct Movie: Codable {
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
    }
}

struct MoviesResponse: Codable {
    let results: [Movie]
}
