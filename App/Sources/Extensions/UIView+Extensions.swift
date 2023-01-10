//
//  UIView+Extensions.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 09/01/23.
//

import UIKit

extension UIView {
    func createClip() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        return image
    }
}
