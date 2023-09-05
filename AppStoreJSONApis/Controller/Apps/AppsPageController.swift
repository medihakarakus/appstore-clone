//
//  AppsController.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 21.02.23.
//

import UIKit


class AppsPageController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "id"
    let headerId = "headerId"
    
    var groups = [AppGroup]()
    var socialApps = [SocialApp]()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
        fetchData()
        
    }
    
    fileprivate func fetchData() {
        
        var group1: AppGroup?
        var group2: AppGroup?
        var group3: AppGroup?
        
        // help you sync your data fetches together
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchTopFreeApps { appsGroup, error in
            print("Done with top free apps")
            dispatchGroup.leave()
            group1 = appsGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchMostPlayedMusics { appsGroup, error in
            print("Done with most played music")
            dispatchGroup.leave()
            group2 = appsGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopFreeBooks { appsGroup, error in
            print("Done with free books")
            dispatchGroup.leave()
            group3 = appsGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchSocialApps() { (apps, err) in
            dispatchGroup.leave()
            self.socialApps = apps ?? []
        }
        
        //completion
        dispatchGroup.notify(queue: .main){
            print("completed your dispatch group tasks")
            self.activityIndicatorView.stopAnimating()
            
            if let group = group1{
                self.groups.append(group)
            }
            if let group = group2{
                self.groups.append(group)
            }
            
            if let group = group3{
                self.groups.append(group)
            }

            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        header.appHeaderHorizontalController.socialApps = self.socialApps
        header.appHeaderHorizontalController.collectionView.reloadData()
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        
        let appGroup = groups[indexPath.item]
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalController.appGroup = appGroup
        cell.horizontalController.collectionView.reloadData()
        cell.horizontalController.didSelectHandler = { [weak self]  feedResult in
            let controller = AppDetailController(appId: feedResult.id)
            controller.navigationItem.title = feedResult.name
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
   
    
}
