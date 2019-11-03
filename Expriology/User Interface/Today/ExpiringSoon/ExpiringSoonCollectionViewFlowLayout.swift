//
//  ExpiringSoonCollectionViewFlowLayout.swift
//  Expriology
//
//  Created by Harish Yerra on 11/2/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import UIKit

class ExpiringSoonCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).inset(by: sectionInset).size.width
        
        minimumLineSpacing = 10
        minimumInteritemSpacing = 0
        
        let minColumnWidth = (availableWidth) / 2
        let maxColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxColumns)).rounded(.down)
        itemSize = CGSize(width: cellWidth, height: 115)
    }
    
}
