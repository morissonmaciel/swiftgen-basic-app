//
//  Favorite+ViewModel.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 09/01/23.
//

import Foundation

final class FavoriteViewModel {
    static let shared = FavoriteViewModel()
    var favorites: [Favorite] = []
    
    private init() {
        fetchFavorites()
    }
    
    private func flushData() {
        guard let data = try? JSONEncoder().encode(favorites) else {
            return
        }
        UserDefaults.standard.setValue(data, forKey: StorageKeys.favorites)
    }
    
    func fetchFavorites() {
        guard let data = UserDefaults.standard.data(forKey: StorageKeys.favorites),
              let items = try? JSONDecoder().decode([Favorite].self, from: data) else {
            return
        }
        favorites = items
    }
    
    func favorite(_ item: Favorite) {
        favorites.insert(item, at: 0)
        flushData()
    }
    
    func unfavorite(id: UUID) {
        favorites = favorites.filter {
            $0.id != id
        }
        flushData()
    }
    
    func isFavorited(id: UUID) -> Bool {
        return favorites.first(where: { $0.id == id}) != nil
    }
}
