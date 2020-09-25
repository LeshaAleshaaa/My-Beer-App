//
//  ImageViewExtenstion.swift
//  MyBeer
//
//  Created by Алексей Смицкий on 24.09.2020.
//

import UIKit

// MARK: - UIImageView Extension

extension UIImageView {
    func parseImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
