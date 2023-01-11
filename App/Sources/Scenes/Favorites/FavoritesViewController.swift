//
//  FavoritesViewController.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 09/01/23.
//

import UIKit
import SafariServices

final class FavoritesViewController: UITableViewController {
    private var viewModel = FavoriteViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateContents()
    }
    
    private func prepareTableView() {
        tableView.register(CompactArticleCell.self, forCellReuseIdentifier: CompactArticleCell.identifier)
    }
    
    func updateContents() {
        tableView.reloadData()
    }
}

extension FavoritesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CompactArticleCell.identifier, for: indexPath) as? CompactArticleCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.favorites[indexPath.row]
        cell.configureCell(with: item.title,
                           ellapsedTime: item.bookmarkedAt.dateISO8610?.ellapsedTime,
                           urlToImage: item.previewImage)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.favorites[indexPath.row]
        
        guard let articleURL = URL(string: item.externalURL ?? "") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: articleURL)
        safariVC.modalPresentationStyle = .popover
        present(safariVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let favorite = viewModel.favorites[indexPath.row]
        let contextOptions = ContextOptions(itemID: favorite.id, title: favorite.title, publishedAt: favorite.bookmarkedAt, externalURL: favorite.externalURL!, previewImage: favorite.previewImage)
        return contextOptions.buildContextualMenu(navigationController: navigationController, favoriteData: favorite)
    }
}
