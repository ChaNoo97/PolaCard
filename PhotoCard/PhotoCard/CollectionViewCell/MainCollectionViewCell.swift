//
//  MainCollectionViewCell.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/18.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var mainImageView: UIImageView!
	@IBOutlet weak var wordingLabel: UILabel!
	@IBOutlet weak var imageDateLabel: UILabel!
	
	static let identfier = "MainCollectionViewCell"
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
