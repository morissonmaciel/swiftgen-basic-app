//
//  Favorite+Model.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 09/01/23.
//

import Foundation

enum FavoriteType: String, Codable {
    case newsAPI = "newsAPI"
}

struct Favorite: Codable {
    var id = UUID()
    let title: String
    let bookmarkedAt: String
    let type: FavoriteType
    let previewImage: String?
    let externalURL: String?
    let articleData: Data
}

extension Favorite {
    static func fromArticle(article: NewsAPIArticle) -> Favorite? {
        guard let data = try? JSONEncoder().encode(article) else { return nil }
        
        return Favorite(id: article.id,
                        title: article.title,
                        bookmarkedAt: Date().toISO8601String(),
                        type: .newsAPI,
                        previewImage: article.urlToImage,
                        externalURL: article.url,
                        articleData: data)
    }
}
