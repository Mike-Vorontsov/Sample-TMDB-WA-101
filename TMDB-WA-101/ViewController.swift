//
//  ViewController.swift
//  TMDB-WA-101
//
//  Created by Michael Vorontsov on 24/05/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var footer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2OWI1OTAzMTFiZjFhYjI3NjBkMjk3ZTQ4MGViM2JlMiIsInN1YiI6IjY0NmJkMWRmMmJjZjY3MDE3MmIyOTUxMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.GBRh-SFoqFGKXv-sRjZsewvQrakSbf0CevG1xFzW2Es"
        ]
        
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")!
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                if let data = data {
                    do {
                        let apiResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
                        
                        for movie in apiResponse.results {
                            DispatchQueue.main.async {
                                let label = UILabel()
                                label.text = movie.title
                                self.stackView.addArrangedSubview(label)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.stackView.addArrangedSubview(self.footer)
                        }
                        
                    } catch {
                        print("decoding error: \(error)")
                    }
                }
                self.loadPage2()
            }
        }).resume()
    }
    
    func loadPage2() {
        
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2OWI1OTAzMTFiZjFhYjI3NjBkMjk3ZTQ4MGViM2JlMiIsInN1YiI6IjY0NmJkMWRmMmJjZjY3MDE3MmIyOTUxMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.GBRh-SFoqFGKXv-sRjZsewvQrakSbf0CevG1xFzW2Es"
        ]
        
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=2&sort_by=popularity.desc")!
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                if let data = data {
                    do {
                        let apiResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
                        
                        for movie in apiResponse.results {
                            DispatchQueue.main.async {
                                let label = UILabel()
                                label.text = movie.title
                                self.stackView.addArrangedSubview(label)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.stackView.addArrangedSubview(self.footer)
                        }
                        
                    } catch {
                        print("decoding error: \(error)")
                    }
                }
            }
        }).resume()

    }
    
    
}

