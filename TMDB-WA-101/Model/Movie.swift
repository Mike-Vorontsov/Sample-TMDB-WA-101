import Foundation

struct Movie: Codable {
    let title: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case poster = "poster_path"
    }
    
    init(title: String, poster: String = "") {
        self.title = title
        self.poster = poster
    }    
    
}

struct MoviesResponse: Codable {
    let results: [Movie]
}
