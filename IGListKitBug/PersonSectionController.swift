//
//  PersonSectionController.swift
//  IGListKitBug
//
//  Created by Weyert de Boer on 25/08/2017.
//  Copyright © 2017 Weyert de Boer. All rights reserved.
//

import IGListKit

final class PersonSectionController: ListGenericSectionController<Person> {
    
    fileprivate let topInset: CGFloat
    fileprivate let topLayoutGuide: UILayoutSupport
    
    init(topInset: CGFloat, topLayoutGuide: UILayoutSupport) {
        self.topInset = topInset
        self.topLayoutGuide = topLayoutGuide
        super.init()

        // The minimum spacing to use between items in the same row.
        let itemPadding: CGFloat =  13.0
        self.minimumInteritemSpacing = itemPadding
        // The minimum spacing to use between rows of items.
        self.minimumLineSpacing = 0.0
        // The margins used to lay out content in the section controller.
        self.inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: itemPadding, right: 0.0)
    }
    
    override func didSelectItem(at index: Int) {
        print("Selected Item")
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let cellWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 144 : 236
        let cellHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 197 : 306
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: PersonCell.self, for: self, at: index) as? PersonCell
            else { fatalError("Missing context or cell is wrong type") }

        cell.bindViewModel(object)
        return cell
    }
}
