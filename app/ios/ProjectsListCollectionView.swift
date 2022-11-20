//
//  ProjectsListCollectionView.swift
//  RTABMapApp
//
//  Created by Karan Sehgal on 15/11/2022.
//

import Foundation
import UIKit

class ProjectsListCollectionView: UICollectionView {
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    

        print("ProjectListCollectionView")
    }
    
}
