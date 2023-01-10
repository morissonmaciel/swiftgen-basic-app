//
//  HeadlinesViewController.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 09/01/23.
//

import UIKit
import SafariServices

final class HeadlinesViewController: UITableViewController {
    private var searchView: UISearchBar!
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
        tableView.register(ArticleCompactCell.self, forCellReuseIdentifier: ArticleCompactCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchView
    }
    
    func updateContents() {
        newsAPIViewModel.fetchFeatured(category: category) { error in
            if let error = error {
                let alertVC = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                self.present(alertVC, animated: true)
                return
            }
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsAPIViewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCompactCell.identifier, for: indexPath) as? ArticleCompactCell else {
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
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let bookmarkAction = UIAction(title: "Favorite", image: UIImage(systemName: "heart")) { _ in
                self.bookmarkViewModel.favorite(item)
            }
            
            let removeBookmarkAction = UIAction(title: "Unfavorite", image: UIImage(systemName: "heart.slash"), attributes: [.destructive]) { _ in
                self.bookmarkViewModel.unfavorite(id: item.id)
            }
            
            var actions: [UIAction] = []
            actions.append(self.bookmarkViewModel.isFavorited(id: item.id) ? removeBookmarkAction : bookmarkAction)
            
            return UIMenu(children: actions)
        }
    }
}
