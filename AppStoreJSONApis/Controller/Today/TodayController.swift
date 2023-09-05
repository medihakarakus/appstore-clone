//
//  TodayController.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 01.03.23.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{

    var items = [TodayItem]()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        fetchData()
        
        navigationController?.isNavigationBarHidden = true
        collectionView.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        
    }
    fileprivate func fetchData() {
        
        var topFreeGroup: AppGroup?
        var mostPlayedGroup: AppGroup?
        
        // help you sync your data fetches together
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchTopFreeApps { appsGroup, error in
            print("Done with top free apps")
            dispatchGroup.leave()
            topFreeGroup = appsGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchMostPlayedMusics { appsGroup, error in
            print("Done with most played music")
            dispatchGroup.leave()
            mostPlayedGroup = appsGroup
        }
        
        //completion
        dispatchGroup.notify(queue: .main){
            print("completed your dispatch group tasks")
            self.activityIndicatorView.stopAnimating()

            self.items = [
                TodayItem.init(category: "LIFE HACK" , title: "Utilizing your Time", image: UIImage(#imageLiteral(resourceName: "garden")), description: "All the tools and apps need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, apps: []),
                TodayItem.init(category: "Daily List" , title: topFreeGroup?.feed.title ?? "", image: UIImage(#imageLiteral(resourceName: "garden")), description: "", backgroundColor: .white, cellType: .multiple, apps: topFreeGroup?.feed.results ?? []),
                TodayItem.init(category: "HOLIDAYS" , title: "Travel on a Budget", image: UIImage(#imageLiteral(resourceName: "holiday")), description: "Find out all you need to know on how to travelwithout packing everything!", backgroundColor: .init(cgColor: .init(genericCMYKCyan: 0, magenta: 0, yellow: 0.4, black: 0, alpha: 0.8)), cellType: .single, apps: []),
                TodayItem.init(category: "Daily List" , title: mostPlayedGroup?.feed.title ?? "", image: UIImage(#imageLiteral(resourceName: "garden")), description: "", backgroundColor: .white, cellType: .multiple, apps: mostPlayedGroup?.feed.results ?? [])
            ]
            self.collectionView.reloadData()
        }
    }
    
    var appFullScreenController: AppFullScreencontroller!
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullscreen(indexPath)
        default:
            showSingleAppFullscreen(indexPath)
        }
    }
    
    fileprivate func showDailyListFullscreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps = self.items[indexPath.item].apps
        let nc = BackEnabledNavigationController(rootViewController: fullController)
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true)
    }
    
    fileprivate func showSingleAppFullscreen(_ indexPath: IndexPath) {
        // #1
        setupSingleAppFullscreenController(indexPath)
        
        // #2 setup fullscreen in its starting position
        setupAppFullscreenStartingPosition(indexPath)
        
        // #3 begin the fullscreen animation
        beginAnimationAppFullscreen(indexPath)
    }
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let appFullScreenController = AppFullScreencontroller()
        appFullScreenController.todayItem = items[indexPath.row]
        appFullScreenController.dismissHandler = {
            self.handleAppFullscreenDismissal()
        }
        appFullScreenController.view.layer.cornerRadius = 16
        self.appFullScreenController = appFullScreenController

        // #1 setup our pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        appFullScreenController.view.addGestureRecognizer(gesture)

        // #2 add a blue effect view
        // #3 not to interfere with our UITableview scrolling
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    var appFullscreenBeginOffset: CGFloat = 0
    @objc func handleDrag(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            appFullscreenBeginOffset = appFullScreenController.tableView.contentOffset.y
        }
        if appFullScreenController.tableView.contentOffset.y > 0 {
            return
        }
        
        let translationY = gesture.translation(in: appFullScreenController.view).y
        
        if gesture.state == .changed {
            if translationY > 0 {
                let trueOffset = translationY - appFullscreenBeginOffset
                var scale = 1 - trueOffset / 1000
                
                scale = min(1, scale)
                scale = max(0.5, scale)
                
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                appFullScreenController.view.transform = transform
            }
        } else if gesture.state == .ended {
            if translationY > 0 {
                handleAppFullscreenDismissal()
            }
        }
    }
    var anchoredConstraints: AnchoredConstraints?
    
    fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        let fullscreenView = appFullScreenController.view!
        view.addSubview(fullscreenView)
        addChild(appFullScreenController )
        
        self.collectionView.isUserInteractionEnabled = false
        
        setupAppStartingCellFrame(indexPath)
        
        guard let startingFrame = self.startingFrame else { return }
        
        // auto layouts constraints animations
        // 4 anchors
        
        self.anchoredConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))

        self.view.layoutIfNeeded()
    }
    
    fileprivate func setupAppStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // absolute coordinates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
    }
    
    fileprivate func beginAnimationAppFullscreen(_ indexPath: IndexPath) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 1
            
            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts animation

            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0, 0]) as? AppFullScreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    var startingFrame: CGRect?
    @objc func handleAppFullscreenDismissal() {
        // access startingFrame
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 0
            self.appFullScreenController.view.transform = .identity
            
            self.appFullScreenController.tableView.contentOffset = .zero
            guard let startingFrame = self.startingFrame else { return }
            
            self.anchoredConstraints?.top?.constant = startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded() // starts animation
            
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0, 0]) as? AppFullScreenHeaderCell else { return }
            self.appFullScreenController.closeButton.alpha = 0
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullScreenController.view?.removeFromSuperview()
            self.appFullScreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = items[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        return cell
    }
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
        let collectionView = gesture.view
        // figure out which cell were clicking out
        var superView = collectionView?.superview
        while superView != nil {
            if let cell = superView as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                let apps = self.items[indexPath.item].apps
                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                fullController.apps = apps
                let nc = BackEnabledNavigationController(rootViewController: fullController)
                nc.modalPresentationStyle = .fullScreen
                present(nc, animated: true)
                return
            }
            superView = superView?.superview
        }
        
       
        
    }
    static let cellSize: CGFloat = 500
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
    
    
}
