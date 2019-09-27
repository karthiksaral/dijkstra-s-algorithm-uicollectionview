//
//  Node.swift
//  CollectionNxN
//
//  Created by Karthikeyan A. on 26/09/19.
//  Copyright © 2019 Aravind. All rights reserved.
//

import Foundation
import UIKit

class Node: NSObject {
    var value: String
    var distance, column, row : Int
    var path: [Any]?
    
    //    override var description: String   {
    //        return String(format: "Value: %@ \nDistance: %ld\nPosition: (%ld, %ld)", value, distance, row, column)
    //       }
    
    init(distance: Int, column: Int, row: Int, path: [Any], value: String) {
        self.path = path
        self.distance = distance
        self.column = column
        self.row = row
        self.value = value
        super.init()
    }
}
