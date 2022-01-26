//
//  CustomCollectionViewCell.swift
//  TableViewRefreshTest
//
//  Created by Junhyeong Hong on 2022/01/24.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    override var reuseIdentifier: String? {
        "CustomCollectionViewCell"
    }
    
    let label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       addSubview(label)
   }

   required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
   }
}
