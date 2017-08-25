//
//  LoadingView.swift
//  IGListKitBug
//
//  Created by Weyert de Boer on 25/08/2017.
//  Copyright © 2017 Weyert de Boer. All rights reserved.
//

import UIKit
import SnapKit

final class LoadingView: UIView {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Loading..."
        label.numberOfLines = 0
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.lessThanOrEqualToSuperview().offset(-15.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
