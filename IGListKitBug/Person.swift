//
//  Person.swift
//  IGListKitBug
//
//  Created by Weyert de Boer on 25/08/2017.
//  Copyright © 2017 Weyert de Boer. All rights reserved.
//

import IGListKit

typealias RankedPersonItem = (item: Person, rank: Double)
func filter(items: [Person], query: String = "") -> [Person] {
    print("Query: \(query)")
    if query.isEmpty {
        return items
    }
    
    var rankedItems: [RankedPersonItem] = []
    for item in items {
        let itemTitle = item.name.lowercased()
        let itemScore = itemTitle.score(word: query)
        if itemScore <= 0.5 {
            continue
        }
        
        rankedItems.append(RankedPersonItem(item: item, rank: itemScore))
    }
    
    let sortedItems = rankedItems.sorted { (x, y) -> Bool in
        return x.rank > y.rank
    }
    
    var allItems = [Person]()
    for item in sortedItems {
        allItems.append(item.item)
    }
    
    print("allItems: \(allItems.count)")
    return allItems
}

final class Person: ListDiffable {
    
    let name: String
    let image: String
    
    init(name: String) {
        self.name = name
        self.image = "http://lorempixel.com/200/300/people"
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return (name + image) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
