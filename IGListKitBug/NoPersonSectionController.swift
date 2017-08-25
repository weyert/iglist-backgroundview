//
//  NoPersonSectionController.swift
//  IGListKitBug
//
//  Created by Weyert de Boer on 25/08/2017.
//  Copyright © 2017 Weyert de Boer. All rights reserved.
//

import UIKit
import IGListKit

final class NoPersonSectionController: ListSectionController {
    
    fileprivate let topInset: CGFloat
    fileprivate let topLayoutGuide: UILayoutSupport
    
    init(topInset: CGFloat, topLayoutGuide: UILayoutSupport) {
        self.topInset = topInset
        self.topLayoutGuide = topLayoutGuide
        super.init()
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
        guard let cell = collectionContext?.dequeueReusableCell(of: NoPersonCell.self, for: self, at: index) as? NoPersonCell
            else { fatalError("Missing context or cell is wrong type") }
        return cell
    }
}
