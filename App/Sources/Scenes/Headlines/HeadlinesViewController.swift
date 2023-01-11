//
//  HeadlinesViewController.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 09/01/23.
//

import UIKit
import SwiftUI
import SafariServices

final class HeadlinesViewController: UITableViewController {
    private var searchView: UISearchBar!
    private var refreshView: UIRefreshControl!
    private var newsAPIViewModel = NewsAPIViewModel()
    private var bookmarkViewModel = FavoriteViewModel.shared
    
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        prepareNavigation()
        prepareSearchBar()
        prepareTableView()
        
        updateContents()
    }
    
    func prepareNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func prepareSearchBar() {
        searchView = UISearchBar()
        searchView.autocapitalizationType = .none
        searchView.autocorrectionType = .yes
        searchView.placeholder = "Search"
    }
    
    func prepareTableView() {
        refreshView = UIRefreshControl()
        refreshView.tintColor = .secondaryLabel
        refreshView.addTarget(self, action: #selector(updateContents), for: .valueChanged)
        
        tableView.refreshControl = refreshView
        tableView.register(CompactArticleCell.self, forCellReuseIdentifier: CompactArticleCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchView
    }
    
    @objc
    func updateContents() {
        newsAPIViewModel.fetchFeatured(category: category) { error in
            if let error = error {
                let alertVC = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                self.present(alertVC, animated: true)
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.tableView.reloadData()
                self.refreshView.endRefreshing()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsAPIViewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CompactArticleCell.identifier, for: indexPath) as? CompactArticleCell else {
            return UITableViewCell()
        }
        
        let item = newsAPIViewModel.items[indexPath.row]
        cell.configureCell(with: item.title, ellapsedTime: item.ellapsedTime, urlToImage: item.urlToImage)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = newsAPIViewModel.items[indexPath.row]
        
        guard let articleURL = URL(string: article.url) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: articleURL)
        safariVC.modalPresentationStyle = .popover
        present(safariVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = newsAPIViewModel.items[indexPath.row]
        let contextOptions = ContextOptions(itemID: item.id, title: item.title, publishedAt: item.publishedAt, externalURL: item.url, previewImage: item.urlToImage)
        return contextOptions.buildContextualMenu(navigationController: navigationController, favoriteData: Favorite.fromArticle(article: item))
    }
}
