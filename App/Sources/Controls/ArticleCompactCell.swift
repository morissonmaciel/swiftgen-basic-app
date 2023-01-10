//
//  ArticleCompactCell.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 09/01/23.
//

import UIKit

final class ArticleCompactCell: UITableViewCell {
    static let identifier = "FeaturedCell"
    
    var previewImage: UIImageView!
    var titleLabel: UILabel!
    var ellapsedLabel: UILabel!
    var currentDataTask: URLSessionDataTask?
    var previewImageHeightAnchor: NSLayoutConstraint!
    var contentsLeadingAnchor: NSLayoutConstraint!
    
    func configureCell(with title: String, ellapsedTime: String?, urlToImage: String?) {
        initializeCell()
        
        titleLabel.text = title
        ellapsedLabel.text = ellapsedTime
        
        guard let imageSource = URL(string: urlToImage ?? "") else {
            currentDataTask?.cancel()
            previewImage.image = UIImage()
            previewImageHeightAnchor.constant = 0
            contentsLeadingAnchor.constant = 0
            return
        }
        
        fetchImage(source: imageSource)
    }
    
    private func initializeCell() {
        if previewImage == nil {
            previewImage = UIImageView()
            previewImage.contentMode = .scaleAspectFill
            previewImage.layer.cornerRadius = 6
            previewImage.clipsToBounds = true
            previewImage.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(previewImage)
            previewImage.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
            previewImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
            previewImage.widthAnchor.constraint(equalTo: previewImage.heightAnchor, multiplier: 16/9).isActive = true
            previewImageHeightAnchor = previewImage.heightAnchor.constraint(equalToConstant: 0)
        }
        previewImageHeightAnchor.constant = 80
        previewImageHeightAnchor.isActive = true
        
        if titleLabel == nil {
            titleLabel = UILabel()
            titleLabel.numberOfLines = 0
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(titleLabel)
            titleLabel.topAnchor.constraint(equalTo: previewImage.topAnchor).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -12).isActive = true
            contentsLeadingAnchor = titleLabel.leadingAnchor.constraint(equalTo: previewImage.trailingAnchor)
        }
        contentsLeadingAnchor.constant = 12
        contentsLeadingAnchor.isActive = true
        
        if ellapsedLabel == nil {
            ellapsedLabel = UILabel()
            ellapsedLabel.numberOfLines = 1
            ellapsedLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            ellapsedLabel.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(ellapsedLabel)
            ellapsedLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
            ellapsedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -12).isActive = true
            ellapsedLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
            ellapsedLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        }
    }
    
    private func fetchImage(source: URL?) {
        previewImage.image = UIImage()
        currentDataTask?.cancel()
        
        guard let source = source else {
            return
        }
        
        let request = URLRequest(url: source)
        currentDataTask = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            let resizedImage = image.scalePreservingAspectRatio(targetSize: CGSize(width: 100, height: 80))
            
            DispatchQueue.main.async {
                self.previewImage.image = resizedImage
            }
        }
        
        currentDataTask?.resume()
    }
}

