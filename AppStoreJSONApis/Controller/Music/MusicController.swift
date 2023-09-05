//
//  MusicController.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 08.03.23.
//

import UIKit

class MusicController: BaseListController, UICollectionViewDelegateFlowLayout{
    
    fileprivate let cellId = "cellId"
    fileprivate let footerId = "footerId"
    var results = [Result]()
    fileprivate let searchTerm = "condon"
    var isPaginating = false
    var isDonePaginating = false
    
    override init() {
        super.init()
        
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        
        fetchData()
        
    }
    
    fileprivate func fetchData() {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=0&limit=20"
        Service.shared.fetchGenericJSONData(urlString: urlString) { (searchResult: SearchResult?, err) in
            if let err = err {
                print("Failed to paginate data..", err)
                return
            }
            
            self.results = searchResult?.results ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let heigt: CGFloat = isDonePaginating ? 0 : 100
        return .init(width: view.frame.width, height: heigt)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrackCell
        let track = results[indexPath.item]
        cell.namaLabel.text = track.trackName
        cell.imageView.sd_setImage(with: URL(string:track.artworkUrl100))
        cell.subtitleLabel.text = "\(track.artistName ?? "") • \(track.collectionName ?? "")"
        
        // initiate pagination
        
        if indexPath.item == results.count - 1 && !isPaginating{
            print("fetch more data")
            isPaginating = true
            let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(results.count)&limit=20"
            Service.shared.fetchGenericJSONData(urlString: urlString) { (searchResult: SearchResult?, err) in
                if let err = err {
                    print("Failed to paginate data..", err)
                    return
                }
                
                if searchResult?.results.count == 0 {
                    self.isDonePaginating = true
                }
                sleep(2)
                
                self.results += searchResult?.results ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.isPaginating = false
            }
        }
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
}
