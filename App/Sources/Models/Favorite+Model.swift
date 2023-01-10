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

