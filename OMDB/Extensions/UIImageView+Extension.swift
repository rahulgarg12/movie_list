//
//  UIImageView+Extension.swift
//  OMDB
//
//  Created by Rahul Garg on 24/04/19.
//  Copyright © 2019 Rahul Garg. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setImageWith(urlString: String?) {
        if let _urlString = urlString, let url = URL(string: _urlString) {
            self.kf.indicatorType = .activity
            self.kf.setImage(with: url)
        } else {
            self.image = nil
        }
    }
    
}
