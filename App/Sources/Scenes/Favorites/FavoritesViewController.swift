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
        tableView.register(ArticleCompactCell.self, forCellReuseIdentifier: ArticleCompactCell.identifier)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCompactCell.identifier, for: indexPath) as? ArticleCompactCell else {
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
        let item = viewModel.favorites[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let shareClipAction = UIAction(title: "Share Clip", image: UIImage(systemName: "rectangle.and.paperclip")) { _ in
                Task {
                    guard let clipImage = tableView.cellForRow(at: indexPath)?.createClip() else { return }
                    let vc = UIActivityViewController(activityItems: [clipImage], applicationActivities: [])
                    self.present(vc, animated: true)
                }
            }
            
            let shareURLAction = UIAction(title: "Share Source", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                Task {
                    guard let sourceURL = URL(string: item.externalURL ?? "") else { return }
                    let vc = UIActivityViewController(activityItems: [sourceURL], applicationActivities: [])
                    self.present(vc, animated: true)
                }
            }
            
            let removeBookmarkAction = UIAction(title: "Unfavorite", image: UIImage(systemName: "heart.slash"), attributes: [.destructive]) { _ in
                self.viewModel.unfavorite(id: item.id)
                self.updateContents()
            }
            
            return UIMenu(children: [shareClipAction, shareURLAction, removeBookmarkAction])
        }
    }
}
