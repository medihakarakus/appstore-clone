//
//  AppsCompositionalView.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 09.03.23.
//

import SwiftUI

class CompositionalController: UICollectionViewController {

    init() {
        
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _ ) in
            
            if sectionNumber == 0 {
                return CompositionalController.topSection()
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 3)))
                item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group )
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets.leading = 16
                let kind = UICollectionView.elementKindSectionHeader
                section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)]
                
                return section
            }
           
        }
        super.init(collectionViewLayout: layout)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CompositionalHeader
        var title: String?
        if indexPath.section == 1 {
            title = freeApps?.feed.title
        } else if indexPath.section == 2 {
            title = freeBooks?.feed.title
        } else {
            title = mostPlayedMusics?.feed.title
        }
        header.label.text = title
        return header
    }
    
    static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 16
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group )
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        return section
    }
    
    var socialApps = [SocialApp]()
    var freeApps: AppGroup?
    var freeBooks: AppGroup?
    var mostPlayedMusics: AppGroup?
    
    private func fetchApps() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        Service.shared.fetchTopFreeApps { (appGroup, err) in
            self.freeApps = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopFreeBooks{ (appGroup, err) in
            self.freeBooks = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchMostPlayedMusics { (appGroup, err) in
            self.mostPlayedMusics = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchSocialApps { (apps, err) in
            self.socialApps = apps ?? []
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        0
    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section ==  0 {
//            return socialApps.count
//        } else if section == 1 {
//            return freeApps?.feed.results.count ?? 0
//        } else if section == 2 {
//            return freeBooks?.feed.results.count ?? 0
//        } else {
//            return mostPlayedMusics?.feed.results.count ?? 0
//        }
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let appId: String
//        if indexPath.section == 0 {
//            appId = socialApps[indexPath.item].id
//        } else if indexPath.section == 1 {
//            appId = freeApps?.feed.results[indexPath.item].id ?? ""
//        } else if indexPath.section == 2 {
//            appId = freeBooks?.feed.results[indexPath.item].id ?? ""
//        } else {
//            appId = mostPlayedMusics?.feed.results[indexPath.item].id ?? ""
//        }
//        let appDetailController = AppDetailController(appId: appId)
//        navigationController?.pushViewController(appDetailController, animated: true)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        switch indexPath.section {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
//            let socialApps = self.socialApps[indexPath.item]
//            cell.textLabel.text = socialApps.tagline
//            cell.companyLabel.text = socialApps.name
//            cell.imageView.sd_setImage(with: URL(string: socialApps.imageUrl))
//            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
//            var appGroup: AppGroup?
//            if indexPath.section ==  1 {
//                appGroup = freeApps
//            } else if indexPath.section == 2 {
//                appGroup = freeBooks
//            } else {
//                appGroup = mostPlayedMusics
//            }
//
//            let app = appGroup?.feed.results[indexPath.item]
//            cell.imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
//            cell.companyLabel.text = app?.artistName
//            cell.nameLabel.text = app?.name
//            return cell
//        }
//
//    }
    
    class CompositionalHeader: UICollectionReusableView {
        let label = UILabel(text: "EDitors choice games", font: .boldSystemFont(ofSize: 32))
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(label)
            label.fillSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    let headerId = "headerId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: "smallCellId")
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        navigationItem.rightBarButtonItem = .init(title: "Fetch Musics", style: .plain, target: self, action: #selector(fetchMusics))
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)

        setupDiffableDatasource()
    }
    
    @objc fileprivate func handleRefresh()  {
        collectionView.refreshControl?.endRefreshing()
        var snapshot = difffableDataSource.snapshot()
        snapshot.deleteSections([.mostPlayedMusics])
        difffableDataSource.apply(snapshot)
    }
    
    @objc func fetchMusics()  {
        Service.shared.fetchMostPlayedMusics { (appGroup, err) in
            var snapshot = self.difffableDataSource.snapshot()
            snapshot.insertSections([.mostPlayedMusics], afterSection: .topSocial)
            snapshot.appendItems(appGroup?.feed.results ?? [], toSection: .mostPlayedMusics)
            self.difffableDataSource.apply(snapshot)
            
        }
    }
    
    enum AppSection {
        case topSocial
        case topApps
        case topBooks
        case mostPlayedMusics
    }
    
    lazy var difffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object ) -> UICollectionViewCell? in
        
        if let object = object as? SocialApp {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
            cell.app = object
            return cell
        } else if let object = object as? FeedResult {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
            cell.app = object
            cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
            return cell
        }
        return nil
    }
    
    @objc func handleGet(button: UIView) {
        
        var superView = button.superview
        while superView != nil {
            if let cell = superView as? UICollectionViewCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                guard let objectClickedOnto = difffableDataSource.itemIdentifier(for: indexPath) else { return }
                var snapshot = difffableDataSource.snapshot()
                snapshot.deleteItems([objectClickedOnto])
                difffableDataSource.apply(snapshot)
            }
            superView = superView?.superview
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = difffableDataSource.itemIdentifier(for: indexPath)
        if let object = object as? SocialApp {
            let appDetailController = AppDetailController(appId: object.id)
            navigationController?.pushViewController(appDetailController, animated: true)
        } else if let object = object as? FeedResult {
            let appDetailController = AppDetailController(appId: object.id)
            navigationController?.pushViewController(appDetailController, animated: true)
        }
    }
    
    private func setupDiffableDatasource() {
        collectionView.dataSource = difffableDataSource
        difffableDataSource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: self.headerId, for: indexPath) as!CompositionalHeader
            let snapshot = self.difffableDataSource.snapshot()
            let object = self.difffableDataSource.itemIdentifier(for: indexPath)
            let section = snapshot.sectionIdentifier(containingItem: object!)
            if section == .topApps {
                header.label.text = "Top Apps"
            } else if section == .topBooks{
                header.label.text = "Top Books"
            } else if section == .mostPlayedMusics {
                header.label.text = "Most Played Musics"
            }
            return header
        })
        
        Service.shared.fetchSocialApps { socialApps, err in
            Service.shared.fetchTopFreeApps { appGroup, err in
                Service.shared.fetchTopFreeBooks { booksGroup, err in
                    var snapshot = self.difffableDataSource.snapshot()
                    // top socoial
                    snapshot.appendSections([.topSocial, .topApps, .topBooks])
                    snapshot.appendItems(socialApps ?? [], toSection: .topSocial)
                    
                    // top apps
                    let objects = appGroup?.feed.results ?? []
                    snapshot.appendItems(objects, toSection: .topApps)
                    
                    // top books
                    snapshot.appendItems(booksGroup?.feed.results ?? [], toSection: .topBooks)
                    self.difffableDataSource.apply(snapshot)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

struct AppView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CompositionalController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
}


struct AppsCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .ignoresSafeArea(.all)
    }
}
