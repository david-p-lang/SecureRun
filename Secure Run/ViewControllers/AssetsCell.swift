//
//  AssetsCell.swift
//  Secure Run
//
//  Created by David Lang on 8/9/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit

class AssetsCell: UICollectionViewCell {
   
    class var reuseIdentifier: String {
        return "AssetCell"
    }
    var representedAssetIdentifier: String = ""
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .orange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
