//
//  ViewController.swift
//  CollectionNxN
//
//  Created by Karthikeyan A. on 24/09/19.
//  Copyright © 2019 Aravind. All rights reserved.
//

import UIKit

class PathCell : UICollectionViewCell{
    var cellNode: Node?
    
}

class ViewController: UIViewController {
    
    // set initial count
    var setCollectionCount = 2
    // setter for collectionview data source
    let dataSource = NDataSource()
    
    // created the run time collectionview layout
    lazy var collectionViewFlowLayout : CustomFlowLayout = {
        let layout = CustomFlowLayout(display: .grid)
        return layout
    }()
    
    // set to complier the assigned property
    @IBOutlet weak var pathCollectionView: UICollectionView!{
        didSet{
            self.pathCollectionView.collectionViewLayout = self.collectionViewFlowLayout
            self.pathCollectionView.dataSource = self.dataSource
            self.pathCollectionView.delegate = self.dataSource
            self.pathCollectionView.register(PathCell.self, forCellWithReuseIdentifier: "PathCell")
        }
    }
    
    //MARK:- loadView
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.dataSource.data.addAndNotify(observer: self) { [weak self] in
//            self?.pathCollectionView.reloadData()
//        }
        updateDataSet()
    }
    
    //MARK:- handle bar button action for add and reset
    @IBAction func handleBarButtons(_ sender: UIBarButtonItem) {
        if sender.tag == 1 { //show alert for set the size
            UIAlertController.init(title: "Enter your input", cancelButtonTitle: "Cancel", okButtonTitle: "Submit", onCompletion: { result in
                if !result.get().isEmpty { self.setCollectionCount = Int(result.get())! * Int(result.get())!
                    UserDefaults.standard.set(Int(result.get())!, forKey: CommonKey.countName)
                    self.updateDataSet()
                }
            }).show()
        }else {
            // reset
            setCollectionCount = 2
            UserDefaults.standard.set(setCollectionCount, forKey: CommonKey.countName)
            updateDataSet()
            
        }
    }
    
    
    // MARK: - Data Manager
    func updateDataSet(){
        self.dataSource.data.value.removeAll()
        self.dataSource.data.twoDimensionArray.removeAll()
        for i in 0 ... self.setCollectionCount - 1{
            var createRowArray: [Any] = []
            for j in 0 ... self.setCollectionCount - 1{
                //create original Cell
                if  i == j,j == 0{
                    let node = Node(distance: 0, column: 0, row: 0, path: [], value: "")
                    node.value = "0"
                    node.path?.append(node)
                    createRowArray.append(node)
                    dataSource.data.value.append(node)
                } else {
                    //create the valid cell
                    let node = Node(distance: 0, column: 0, row: 0, path: [], value: "")
                    node.value = "0"
                    createRowArray.append(node)
                    dataSource.data.value.append(node)
                }
            }
             self.dataSource.data.twoDimensionArray.append(createRowArray)
            
           //self.dataSource.data.value.append(.white)
        }
        // refresh 
        self.pathCollectionView.reload()
    }
    
}

