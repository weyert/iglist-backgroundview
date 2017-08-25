//
//  CollectionFeed.swift
//  IGListKitBug
//
//  Created by Weyert de Boer on 25/08/2017.
//  Copyright © 2017 Weyert de Boer. All rights reserved.
//

import UIKit
import IGListKit

protocol CollectionFeedDelegate: class {
    func loadFromNetwork(provider: CollectionFeed)
    func didTapBackground(_ sender: CollectionFeed)
}

final class CollectionFeed: NSObject, UIScrollViewDelegate {
    
    enum Status {
        case idle
        case loading
    }
    
    let adapter: ListAdapter
    public private(set) var status: Status = .idle
    private weak var delegate: CollectionFeedDelegate? = nil
    private var refreshBegin: TimeInterval = -1
    
    var collectionView: UICollectionView! {
        get {
            if let collectionView = self.adapter.collectionView {
                collectionView.alwaysBounceVertical = true
                return collectionView
            }
            return nil
        }
    }
    
    init(viewController: UIViewController, delegate: CollectionFeedDelegate) {
        self.adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: viewController)
        self.delegate = delegate
        super.init()
        self.adapter.scrollViewDelegate = self
    }
    
    func viewDidLoad() {
        guard let _ = adapter.viewController?.view else {
            assert(true, "Adapter already associated with VC")
            return
        }
        
        // Update to the view controller or collection view when necessary
        if #available(iOS 10, *), let collectionView = collectionView {
            collectionView.refreshControl = UIRefreshControl()
            collectionView.refreshControl?.addTarget(self, action: #selector(CollectionFeed.onRefresh), for: .valueChanged)
            collectionView.refreshControl?.beginRefreshing()
        }
        refresh()
    }
    
    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard collectionView != nil else { return }
        let layout = collectionView.collectionViewLayout
        coordinator.animate(alongsideTransition: { _ in
            layout.invalidateLayout()
        })
    }
    
    private func refresh() {
        status = .loading
        refreshBegin = CFAbsoluteTimeGetCurrent()
        delegate?.loadFromNetwork(provider: self)
        
    }
    
    func backgroundViewTapped() {
        delegate?.didTapBackground(self)
    }
    
    func finishLoading(fromNetwork: Bool) {
        status = .idle
        
        let block = {
            self.adapter.performUpdates(animated: true) { _ in
                guard let collectionView = self.collectionView else { return }
                if fromNetwork {
                    if #available(iOS 10, *) {
                        collectionView.refreshControl?.endRefreshing()
                    }
                }
            }
        }
        
        // delay the refresh control dismissal so the UI isn't too spazzy on fast or non-existent connections
        let remaining = 0.5 - (CFAbsoluteTimeGetCurrent() - refreshBegin)
        if remaining > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + remaining, execute: block)
        } else {
            block()
        }
    }
    
    @objc private func onRefresh(sender: Any) {
        refresh()
    }
}

