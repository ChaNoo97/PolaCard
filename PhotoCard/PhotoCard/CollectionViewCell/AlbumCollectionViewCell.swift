//
//  AlbumCollectionViewCell.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/19.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "AlbumCollectionViewCell"
	
	@IBOutlet weak var firstImageView: UIImageView!
	@IBOutlet weak var albumNameLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
