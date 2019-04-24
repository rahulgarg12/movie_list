//
//  DetailViewController.swift
//  OMDB
//
//  Created by Rahul Garg on 24/04/19.
//  Copyright © 2019 Rahul Garg. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var imdbIdLabel: UILabel!
    
    
    var searchModel: SearchModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarTitle()
        
        setPosterImage()
        setTitle()
        setType()
        setYear()
        setIMDBId()
    }
}


//MARK:- Private Helpers
extension DetailViewController {
    
    private func setNavigationBarTitle() {
        title = searchModel?.title ?? "Details"
    }
    
    private func setPosterImage() {
        posterImageView.setImageWith(urlString: searchModel?.poster)
    }
    
    private func setTitle() {
        if let title = searchModel?.title, !title.isEmpty {
            titleLabel.text = "Title: \(title)"
        } else {
            titleLabel.text = nil
        }
    }
    
    private func setType() {
        if let type = searchModel?.type, !type.isEmpty {
            typeLabel.text = "Type: \(type.capitalized)"
        } else {
            typeLabel.text = nil
        }
    }
    
    private func setYear() {
        if let year = searchModel?.year {
            yearLabel.text = "Year: \(year.timeAgoString)"
        } else {
            yearLabel.text = nil
        }
    }
    
    private func setIMDBId() {
        if let imdbId = searchModel?.imdbId, !imdbId.isEmpty {
            imdbIdLabel.text = "IMDB Id: \(imdbId)"
        } else {
            imdbIdLabel.text = nil
        }
    }
}
