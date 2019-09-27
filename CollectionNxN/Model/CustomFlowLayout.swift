//
//  CustomFlowLayout.swift
//  CollectionNxN
//
//  Created by Karthikeyan A. on 24/09/19.
//  Copyright © 2019 Aravind. All rights reserved.
//

import Foundation

import UIKit

enum CollectionDisplay {
    case grid
}


class CustomFlowLayout : UICollectionViewFlowLayout  {
    
    var display : CollectionDisplay = .grid {
        didSet {
            if display != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    convenience init(display: CollectionDisplay) {
        self.init()
        self.display = display
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
        self.configLayout()
    }
    
    func configLayout() {
        switch display {
        case .grid:
            self.scrollDirection = .vertical
            if let collectionView = self.collectionView {
                let getCount =  UserDefaults.standard.integer(forKey: CommonKey.countName) + 1
                let optimisedWidth = (collectionView.frame.width - minimumInteritemSpacing) / CGFloat(getCount)
                self.itemSize = CGSize(width: optimisedWidth , height: optimisedWidth) // keep as square
            } 
        }
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        self.configLayout()
    }
}

