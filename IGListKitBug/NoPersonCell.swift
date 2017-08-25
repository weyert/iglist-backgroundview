//
//  NoPersonCell.swift
//  IGListKitBug
//
//  Created by Weyert de Boer on 25/08/2017.
//  Copyright © 2017 Weyert de Boer. All rights reserved.
//

import UIKit
import SnapKit

final class NoPersonCell: UICollectionViewCell {
    
    fileprivate let label = UILabel()
    fileprivate let addImageView = UIImageView()
    fileprivate let box = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        box.backgroundColor = .white
        box.layer.borderColor = UIColor.gray.cgColor
        box.layer.borderWidth =  0.5 * UIScreen.main.scale
        
        // Create a white box in thesize of a looks cell
        contentView.addSubview(box)
        box.snp.makeConstraints { make in
            make.width.height.equalTo(self.contentView)
        }
        
        let textPadding = 10
        
        // Label
        let labelFont = UIFont.systemFont(ofSize: 15)
        label.font = labelFont
        label.textColor = .black
        label.text = "Get Started!\nCreate your first contact"
        label.textAlignment = .center
        label.numberOfLines = 0
        box.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(box).offset(textPadding)
            make.right.equalTo(box).offset(-textPadding)
            make.bottom.equalTo(box).offset(-textPadding)
        }
        
        addImageView.backgroundColor = .darkGray
        box.addSubview(addImageView)
        addImageView.snp.makeConstraints { make in
            make.centerX.equalTo(box)
            make.bottom.equalTo(label.snp.top).offset(-20)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
    }
}
