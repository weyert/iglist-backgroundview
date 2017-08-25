//
//  PersonCell.swift
//  IGListKitBug
//
//  Created by Weyert de Boer on 25/08/2017.
//  Copyright © 2017 Weyert de Boer. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit

final class PersonCell: UICollectionViewCell, ListBindable {
    
    fileprivate let label = UILabel()
    fileprivate let imageView = UIImageView()
    private var imageDownloadTask: URLSessionDataTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? Person else { return }
        
        label.text = viewModel.name
        
        let imageUrl = viewModel.image + "?cacheBuster=" + Date().timeIntervalSince1970.description
        guard let imageURL = URL(string: imageUrl) else {
            return
        }
        
        imageDownloadTask = imageView.loadImage(imageURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageDownloadTask?.cancel()
    }
    
    private func setup() {
        imageView.backgroundColor = .lightGray
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        let labelFont = UIFont.systemFont(ofSize: 15)
        label.font = labelFont
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.textAlignment = .center
        label.numberOfLines = 0
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
            make.bottom.equalTo(contentView).offset(-10)
        }
    }
}
