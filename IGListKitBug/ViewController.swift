//
//  ViewController.swift
//  IGListKitBug
//
//  Created by Weyert de Boer on 25/08/2017.
//  Copyright © 2017 Weyert de Boer. All rights reserved.
//

import UIKit
import IGListKit

class ViewController: UIViewController {
    
    fileprivate let emptyKey: ListDiffable = "emptyKey" as ListDiffable
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!

    lazy var feed: CollectionFeed = { CollectionFeed(viewController: self, delegate: self) }()

    var availableItems = [
        Person(name: "Elvie Goranson"),
        Person(name: "Imogene Merck"),
        Person(name: "Kaitlin Lamotte"),
        Person(name: "Lawerence Glascock"),
        Person(name: "Sena Prunty"),
        Person(name: "Hertha Deibler"),
        Person(name: "Pandora Costilla"),
        Person(name: "Porfirio Behrends"),
        Person(name: "Kandis Stilwell"),
        Person(name: "Fernande Burrier"),
        Person(name: "Tam Junkins"),
        Person(name: "Roxanna Rothwell"),
        Person(name: "Drew Wease"),
        Person(name: "Kristle Flansburg"),
        Person(name: "Phoebe Palmer"),
        Person(name: "Nikita Bohannon"),
        Person(name: "Diana Copes"),
        Person(name: "Talitha Amen"),
        Person(name: "Yolande Lachowicz"),
        Person(name: "Cordell Haney"),
    ]
    
    var allItems: [Person] = []
    var filteredItems: [Person] = []
    var searchQuery: String = ""
    fileprivate let contentBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Don't let the collection view scroll below the navigation bar
        extendedLayoutIncludesOpaqueBars = false
        
        // Once loaded set the delegate for the search text field to this view controller.
        searchBar.delegate = self

        // Create background view
        contentBackgroundView.backgroundColor = .green
        contentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundViewTapped)))
        collectionView.backgroundColor = UIColor(colorLiteralRed: 247.0 / 255, green: 247.0 / 255, blue: 247.0 / 255, alpha: 1.0)

        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.backgroundView = contentBackgroundView
        feed.adapter.collectionView = collectionView
        feed.adapter.dataSource = self
        feed.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //reload()
    }
    
    func backgroundViewTapped(_ sender: AnyObject) {
        searchBar.resignFirstResponder()
    }
    
    func update(fromNetwork: Bool) {
        filteredItems = filter(items: allItems, query: searchQuery)
        feed.finishLoading(fromNetwork: fromNetwork)
    }
    
    func reload() {
        let delay = Double(arc4random_uniform(3))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.allItems = self.availableItems.filter { item in
                return arc4random_uniform(2) == 0
            }
            
            self.update(fromNetwork: true)
        }
    }
}

// MARK: - ListAdapterDataSource

extension ViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard !allItems.isEmpty else {
            return [emptyKey]
        }
        return filteredItems
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let object = object as? ListDiffable else { fatalError("Object not diffable") }
        if object === emptyKey {
            return NoPersonSectionController(topInset: 0, topLayoutGuide: topLayoutGuide)
        }
        
        return PersonSectionController(topInset: 0, topLayoutGuide: topLayoutGuide)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        switch feed.status {
        case .loading:
            let loadingView = LoadingView()
            return loadingView
        default:
            return self.contentBackgroundView
        }
    }
}

// MARK: - CollectionFeedDelegate

extension ViewController: CollectionFeedDelegate {
    
    func loadFromNetwork(provider: CollectionFeed) {
        reload()
    }
    
    func didTapBackground(_ sender: CollectionFeed) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchedText = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        self.searchQuery = searchedText
        self.update(fromNetwork: false)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.collectionView.allowsSelection = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.collectionView.allowsSelection = true
    }
}

