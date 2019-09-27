//
//  Extensions.swift
//  CollectionNxN
//
//  Created by Karthikeyan A. on 24/09/19.
//  Copyright © 2019 Aravind. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableView {}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        
        return cell
    }
    
}

enum setSizeCount: Int {
    case cellCount
    
}

class colorController {
    private(set) lazy var currentCount = loadCount()
    private let defaults: UserDefaults
    private let defaultsKey = "splitCount"
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func changeCount(to count: setSizeCount) {
        currentCount = count
        defaults.setValue(count.rawValue, forKey: defaultsKey)
    }
    
    private func loadCount() -> setSizeCount {
        let rawValue = defaults.integer(forKey:  defaultsKey)
        return setSizeCount(rawValue: rawValue )!
    }
}

extension UICollectionView{
    func reload(){
        self.reloadData()
    }
}

struct CommonKey{
    static let countName = "Count"
}

