//
//  FilterCollectionViewCell.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/22.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var filteredImage: UIImageView!
	@IBOutlet weak var filterName: UILabel!
	override var isSelected: Bool {
		didSet {
			if isSelected {
				layer.borderColor = UIColor.orange.cgColor
			} else {
				layer.borderColor = UIColor.black.cgColor
			}
		}
	}
	static let identifier = "FilterCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
