//
//  AppsSearchController.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 14.02.23.
//

import UIKit
import SDWebImage


class AppsSearchController: BaseListController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    let cellId = "id123"
    
    fileprivate var appResults = [Result]()
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate let enterSearchTermlabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above.."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId = String(appResults[indexPath.item].trackId)
        let appDetailController = AppDetailController(appId: appId)
        navigationController?.pushViewController(appDetailController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.addSubview(enterSearchTermlabel)
        enterSearchTermlabel.fillSuperview(padding: .init(top: 5, left: 20, bottom: 0, right: 50))
        
        setupSearchBar()
        
  //      fetchITunesApss()
        
    }
    
    fileprivate func setupSearchBar()  {
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        // introduce some delay before performing the search
        // throttling the search
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            Service.shared.fetchApps(searchTerm: searchText) { res, err in
                self.appResults = res?.results ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
        
    }
  
    fileprivate func fetchITunesApss() {
        Service.shared.fetchApps(searchTerm: "Twitter") { (res, err) in
            if let err = err {
                print("Failed to fetch apss:", err )
                return
            }
            self.appResults = res?.results ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        cell.appResult = appResults[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermlabel.isHidden = appResults.count != 0
        return appResults.count
    }
    
}
