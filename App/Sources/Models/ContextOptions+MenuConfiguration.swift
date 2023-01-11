//
//  ContextOptions+MenuConfiguration.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 10/01/23.
//

import Foundation
import SwiftUI
import UIKit

extension ContextOptions {
    func buildReaderScreen() -> UIViewController? {
        guard let sourceURL = URL(string: self.externalURL) else { return nil }
        
        let readerData = ReaderDataModel(title: self.title, sourceURL: sourceURL, publishedAt: self.publishedAt, previewImage: self.previewImage)
        let vc = UIHostingController(rootView: ReaderScene(readerData: readerData))
            
        vc.title = "Article"
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.never
        return vc
    }
    
    func buildContextualMenu(navigationController: UINavigationController? = nil, favoriteData: Favorite? = nil) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let openArticleView = UIAction(title: "Open Article", image: UIImage(systemName: "doc.text.image")) { _ in
                guard let vc = buildReaderScreen() else { return }
                navigationController?.pushViewController(vc, animated: true)
            }

//            let shareClipAction = UIAction(title: "Share Clip", image: UIImage(systemName: "rectangle.and.paperclip")) { _ in
//                let largeContents = tableView.cellForRow(at: indexPath)
//                let clipImage = largeContents!.createClip()
//
//                let vc = UIActivityViewController(activityItems: [clipImage], applicationActivities: [])
//                self.present(vc, animated: true)
//            }
            
            let shareURLAction = UIAction(title: "Share Source", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                guard let sourceURL = URL(string: self.externalURL) else { return }
                let vc = UIActivityViewController(activityItems: [sourceURL], applicationActivities: [])
                navigationController?.present(vc, animated: true)
            }
            
            var actions: [UIAction] = [openArticleView, shareURLAction]
            
            if let favoriteData = favoriteData {
                let bookmarkAction = UIAction(title: "Favorite", image: UIImage(systemName: "heart")) { _ in
                    FavoriteViewModel.shared.favorite(favoriteData)
                }
                
                let removeBookmarkAction = UIAction(title: "Unfavorite", image: UIImage(systemName: "heart.slash"), attributes: [.destructive]) { _ in
                    FavoriteViewModel.shared.unfavorite(id: self.itemID)
                }
                
                actions.append(FavoriteViewModel.shared.isFavorited(id: self.itemID) ? removeBookmarkAction : bookmarkAction)
            }
            
            return UIMenu(children: actions)
        }
    }
}
