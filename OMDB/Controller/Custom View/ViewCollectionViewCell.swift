//
//  ViewCollectionViewCell.swift
//  OMDB
//
//  Created by Rahul Garg on 24/04/19.
//  Copyright © 2019 Rahul Garg. All rights reserved.
//

import Foundation
import UIKit


class ViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var roundedCornerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Do your stuff
        
        setRoundedCorneredView(on: roundedCornerView, cornerRadius: 8)
    }
    
    
    //MARK: Helper Methods
    func configureWith(model: ViewModel?, at indexPath: IndexPath) {
        
        guard let items = model?.result?.searchItems,
            items.count > indexPath.item
            else { return }
        
        let object = items[indexPath.item]

        setPosterImage(from: object)
        setTitle(from: object)
        setType(from: object)
        setYear(from: object)
    }
}


//MARK: Private Helper Methods
extension ViewCollectionViewCell {
    
    private func setRoundedCorneredView(on view: UIView, cornerRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
    }
    
    private func setPosterImage(from object: SearchModel) {
        posterImageView.setImageWith(urlString: object.poster)
    }
    
    private func setTitle(from object: SearchModel) {
        titleLabel.text = object.title
    }
    
    private func setType(from object: SearchModel) {
        typeLabel.text = object.type?.capitalized
    }
    
    private func setYear(from object: SearchModel) {
        yearLabel.text = object.year?.timeAgoString
    }
}
