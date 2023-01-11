//
//  LargeArticleView.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 09/01/23.
//

import UIKit
import SwiftUI

class LargeArticleView: UIView {
    
    var article: NewsAPIArticle
    var contentsStack = UIStackView()
    var imageDataTask: URLSessionDataTask?
    
    init(with article: NewsAPIArticle) {
        self.article = article
        
        super.init(frame: .zero)
        configureContents()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func configureContents() {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = article.title
        titleLabel.font = .systemFont(ofSize: 24)
        contentsStack.addArrangedSubview(titleLabel)
        
        let previewImage = UIImageView()
        previewImage.backgroundColor = .secondarySystemBackground
        previewImage.layer.cornerRadius = 12
        previewImage.clipsToBounds = true
        previewImage.heightAnchor.constraint(equalToConstant: 220).isActive = true
        refreshPreviewImage(for: previewImage)
        contentsStack.addArrangedSubview(previewImage)
        
        let ellapsedLabel = UILabel()
        ellapsedLabel.numberOfLines = 1
        ellapsedLabel.text = article.publishedAt.dateISO8610?.ellapsedTime
        contentsStack.addArrangedSubview(ellapsedLabel)
        
        contentsStack.spacing = 24
        contentsStack.axis = .vertical
        contentsStack.alignment = .fill
        contentsStack.isLayoutMarginsRelativeArrangement = true
        contentsStack.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        
        contentsStack.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentsStack)
    }
    
    func refreshPreviewImage(for imageView: UIImageView) {
        imageView.image = UIImage()
        imageDataTask?.cancel()
        
        guard let urlToImage = article.urlToImage,
              let imageSource = URL(string: urlToImage) else {
            return
        }
        
        imageDataTask = URLSession.shared.dataTask(with: URLRequest(url: imageSource)) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            let resizedImage = image.scalePreservingAspectRatio(targetSize: CGSize(width: 400, height: 220))
            
            DispatchQueue.main.async {
                imageView.image = resizedImage
            }
        }
        
        imageDataTask?.resume()
    }
}

#if DEBUG

struct LargeArticleViewRepresentable: UIViewRepresentable {
    var article: NewsAPIArticle
    
    func makeUIView(context: Context) -> LargeArticleView {
        LargeArticleView(with: article)
    }
    
    func updateUIView(_ uiView: LargeArticleView, context: Context) {
        //
    }
}

struct LargeArticleView_Previews: PreviewProvider {
    static let article = NewsAPIArticle(source: .init(id: nil, name: "The Washington Post"), author: "Erin Blakemore", title: "CDC revamps children's growth charts to reflect higher BMIs - The Washington Post", description: nil, url: "https://www.washingtonpost.com/health/2023/01/09/bmi-childrens-growth-charts-revamped/", urlToImage: "https://www.washingtonpost.com/wp-apps/imrs.php?src=https://arc-anglerfish-washpost-prod-washpost.s3.amazonaws.com/public/BNQPKU4JJNKIK7DQU4M4HQEAQY.jpg&w=1440", publishedAt: "2023-01-09T12:28:18Z", content: nil)
    
    static var previews: some View {
        LargeArticleViewRepresentable(article: Self.article)
    }
}

#endif
