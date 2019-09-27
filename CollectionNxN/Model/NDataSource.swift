//
//  NDataSource.swift
//  CollectionNxN
//
//  Created by Karthikeyan A. on 24/09/19.
//  Copyright © 2019 Aravind. All rights reserved.
//

import Foundation
import UIKit


class GenericDataSource<T> : NSObject {
    var data: DynamicValueSet<[T]> = DynamicValueSet([], [], [], [])
}

class NDataSource : GenericDataSource<Any>, UICollectionViewDataSource, UICollectionViewDelegate {
    //MARK:- collectionview data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PathCell =   collectionView.dequeueReusableCell(for: indexPath)
        if let getNode =   data.value[indexPath.row] as? Node{
            cell.cellNode = getNode
        }
        cell.backgroundColor = indexPath.row == 0 ? .green : .white
        return cell
    }
    //MARK:- collection view delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
       
        // draw path
        if let getNode =   data.value[indexPath.row] as? Node, let cell: PathCell =   collectionView.cellForItem(at: indexPath) as? PathCell{
            self.createPathAlgorithm(getNode, indexPath: indexPath)
            for case let pathNode as Node in data.finalPath{
                let indexpath =  IndexPath(row: (pathNode.row*5)+pathNode.column, section: 0)
                let cellTrack: PathCell =   collectionView.cellForItem(at: indexpath) as! PathCell
                cellTrack.backgroundColor = .blue
                UIView.animate(withDuration: 4.0,  animations: {
                    cellTrack.backgroundColor = .white
                })
                
            }
            cell.backgroundColor = .blue
            UIView.animate(withDuration: 4.0,  animations: {
                cell.backgroundColor = .white
            })
        }
        
        
    }
    
    //MARK: - generating path
    func createPathAlgorithm(_ finalNode: Node, indexPath: IndexPath) {
        let assumeColumn = indexPath.row % 5
        let assumeRow = indexPath.row % 5
        for i in 0 ... assumeRow{
            for j in 0 ... assumeColumn {
                guard let addresses = data.twoDimensionArray[i][j] as? Node else {
                    return
                }
                let currentNode: Node  = addresses
                currentNode.row = i
                currentNode.column = j
                
                //get the columns
                if  j+1 <= assumeColumn {
                    let followingColumnNode: Node  = data.twoDimensionArray[i][j+1] as! Node
                    if currentNode.distance + 1 < followingColumnNode.distance || followingColumnNode.distance == 0         {
                        followingColumnNode.row = i
                        followingColumnNode.column = j+1
                        for  pathNode  in currentNode.path! {
                            followingColumnNode.path?.append(pathNode)
                        }
                        followingColumnNode.path?.append(followingColumnNode)
                        followingColumnNode.distance = currentNode.distance + 1
                        data.twoDimensionArray[i][j+1] = followingColumnNode
                    }
                }
                //finding the next row
                if  i+1 <= assumeRow {
                    let followingColumnNode: Node  = data.twoDimensionArray[i+1][j] as! Node
                    if currentNode.distance + 1 < followingColumnNode.distance || followingColumnNode.distance == 0         {
                        followingColumnNode.row = i+1
                        followingColumnNode.column = j
                        for  pathNode  in currentNode.path! {
                            followingColumnNode.path?.append(pathNode)
                        }
                        followingColumnNode.path?.append(followingColumnNode)
                        followingColumnNode.distance = currentNode.distance + 1
                        data.twoDimensionArray[i+1][j] = followingColumnNode
                    }
                }
            }
        }
        
        let finalNode: Node  = data.twoDimensionArray[assumeRow][assumeColumn] as! Node
        data.finalPath = finalNode.path!
        
        createDataSet()
    }
    
    // MARK: - Data Manager
    func createDataSet(){
        data.value.removeAll()
        data.twoDimensionArray.removeAll()
        let getCount =  UserDefaults.standard.integer(forKey: CommonKey.countName) + 1
        for i in 0 ... getCount - 1{
            var createRowArray: [Any] = []
            for j in 0 ... getCount - 1{
                //create original Cell
                if  i == j,j == 0{
                    let node = Node(distance: 0, column: 0, row: 0, path: [], value: "")
                    node.value = "0"
                    node.path?.append(node)
                    createRowArray.append(node)
                    data.value.append(node)
                } else {
                    let node = Node(distance: 0, column: 0, row: 0, path: [], value: "")
                    node.value = "0"
                    createRowArray.append(node)
                    data.value.append(node)
                }
            }
            data.twoDimensionArray.append(createRowArray)
        }
        
    }
}
