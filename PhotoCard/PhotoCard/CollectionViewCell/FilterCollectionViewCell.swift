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
	let designHelper = UIExtension()
	
	override var isSelected: Bool {
		didSet {
			if isSelected {
				layer.borderWidth = 2
				layer.borderColor = designHelper.color0.cgColor
			} else {
				layer.borderWidth = 2
				layer.borderColor = designHelper.color3.cgColor
			}
		}
	}
	static let identifier = "FilterCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
