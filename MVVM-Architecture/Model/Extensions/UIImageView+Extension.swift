//
//  UIImageView+Extension.swift
//  MVVM-Architecture
//
//  Created by russel on 12/8/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func getImage(from url: URL) {
        kf.setImage(with: url)
    }
}
