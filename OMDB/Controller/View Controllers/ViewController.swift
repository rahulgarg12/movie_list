//
//  ViewController.swift
//  OMDB
//
//  Created by Rahul Garg on 24/04/19.
//  Copyright © 2019 Rahul Garg. All rights reserved.
//

import UIKit
import Kingfisher


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.isPrefetchingEnabled = true
            
            collectionView.prefetchDataSource = self
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    
    var viewModel: ViewModel?
    
    var progressHUD: ProgressHUD?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initProgressHUD()
        showProgressHUD()
        
        initNavigationBar()
        
        viewModel = ViewModel()
        
        viewModel?.isSearchApiInProgress = true
        viewModel?.fetchData(completion: { [weak self] (success, fetchedData) in
            
            self?.viewModel?.isSearchApiInProgress = false
            
            DispatchQueue.main.async {
                self?.hideProgressHUD()
            }
            
            if !success {
                return
            }
            
            let _resultModel = ResultModel(dict: fetchedData)
            if _resultModel.response == APIResponseStatus.success {
                
                self?.viewModel?.page += 1
                
                self?.viewModel?.result = _resultModel
                
                DispatchQueue.main.async {
                    if let indexPaths = self?.getIndexPathsForUpdatedCollectionViewItemsFrom(finalModel: self?.viewModel?.result, fetchedModel: _resultModel) {
                        self?.collectionView.insertItems(at: indexPaths)
                    } else {
                        self?.collectionView.reloadData()
                    }
                }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideProgressHUD()
    }
}


//MARK:- Private Helpers
extension ViewController {
    
    private func initProgressHUD() {
        progressHUD = ProgressHUD(text: "Fetching Data")
        view.addSubview(progressHUD!)
    }
    
    private func showProgressHUD() {
        progressHUD?.show()
    }
    
    private func hideProgressHUD() {
        progressHUD?.hide()
    }
    
    private func initNavigationBar() {
        title = JSONKey().searchText
    }
    
    private func loadMoreImages() {
        viewModel?.fetchData() { [weak self] (success, fetchedData) in
            
            self?.viewModel?.isSearchApiInProgress = false
            
            DispatchQueue.main.async {
                self?.hideProgressHUD()
            }
            
            if !success {
                return
            }
            
            let _resultModel = ResultModel(dict: fetchedData)
            if _resultModel.response == APIResponseStatus.success {
                
                self?.viewModel?.page += 1
                
                _resultModel.searchItems.forEach { self?.viewModel?.result?.searchItems.append($0) }
                
                DispatchQueue.main.async {
                    if let indexPaths = self?.getIndexPathsForUpdatedCollectionViewItemsFrom(finalModel: self?.viewModel?.result, fetchedModel: _resultModel) {
                        self?.collectionView.insertItems(at: indexPaths)
                    } else {
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    private func getIndexPathsForUpdatedCollectionViewItemsFrom(finalModel: ResultModel?, fetchedModel: ResultModel) -> [IndexPath] {
        let fetchedCount = fetchedModel.searchItems.count
        let totalItemCount = finalModel?.searchItems.count ?? 0
        let oldCount = totalItemCount - fetchedCount
        
        var indexPaths = [IndexPath]()
        for i in oldCount..<totalItemCount {
            indexPaths.append(IndexPath(item: i, section: 0))
        }
        
        return indexPaths
    }
}


//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.result?.searchItems.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellReuseIdentifiers().imageCell, for: indexPath) as! ViewCollectionViewCell
        
        cell.configureWith(model: viewModel, at: indexPath)
        
        //pagination
        if let itemCount = viewModel?.result?.searchItems.count,
            itemCount > 0,
            indexPath.item == (itemCount - 1),
            viewModel?.isSearchApiInProgress == false {
            
            viewModel?.isSearchApiInProgress = true
            showProgressHUD()
            loadMoreImages()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers().detailVC) as? DetailViewController else { return }
        detailVC.searchModel = viewModel?.result?.searchItems[indexPath.item]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


//MARK:- UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        var urls = [URL]()
        indexPaths.forEach {
            guard let items = viewModel?.result?.searchItems,
                items.count > $0.item,
                let poster = items[$0.item].poster,
                let posterUrl = URL(string: poster)
                else { return }
            
            urls.append(posterUrl)
        }
        
        let prefetcher = ImagePrefetcher(urls: urls)
        prefetcher.start()
    }
}


//MARK:- UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let itemWidth = (totalWidth - (3 * getItemPadding())) / getRowItemCount()
        return CGSize(width: itemWidth,
                      height: itemWidth + 8 + 46 + 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return getItemPadding()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return getItemPadding()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding = getItemPadding()
        return UIEdgeInsets(top: padding,
                            left: padding,
                            bottom: padding,
                            right: padding)
    }
    
    //MARK: Helper methods
    private func getItemPadding() -> CGFloat {
        return ProjectConstants().imageViewControllerCollectionViewPadding
    }
    
    private func getRowItemCount() -> CGFloat {
        return ProjectConstants().imageViewControllerCollectionViewRowCount
    }
}
