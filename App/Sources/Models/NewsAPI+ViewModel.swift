//
//  FeaturedItem+ViewModel.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 24/12/22.
//

import Foundation

final class NewsAPIViewModel {
    var items: [NewsAPIArticle] = []
    
    func fetchFeatured(category: String? = nil, _ completion: @escaping (Error?) -> Void) {
        let newsSource = URL(string: "https://newsapi.org/v2/top-headlines?country=br&apiKey=\(Keys.apiKey)&category=\(category ?? "")")!
        
        let request = URLRequest(url: newsSource)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(NewsAPIResponse.self, from: data)
                self.items = response.articles
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("JSON for error: \(String(data: data, encoding: .utf8) ?? "")")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }.resume()
    }
}
