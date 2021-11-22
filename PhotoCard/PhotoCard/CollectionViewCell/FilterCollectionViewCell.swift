//
//  FilterCollectionViewCell.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/22.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var filteredImage: UIImageView!
	
	static let identifier = "FilterCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
