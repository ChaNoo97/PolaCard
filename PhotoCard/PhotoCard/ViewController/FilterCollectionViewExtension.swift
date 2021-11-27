//
//  FilterCollectionViewLayout.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/23.
//

import Foundation
import UIKit

extension AddViewController: UICollectionViewDataSource, UICollectionViewDelegate { 

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return ciFilters.filter.count+1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
		
		cell.layer.borderWidth = 1
		
		filterCollectionView.selectItem(at: IndexPath.init(row: 0, section: 0), animated: true, scrollPosition: .init())
		
		if indexPath.row == 0 {
			cell.filteredImage.image = value
			cell.filterName.text = "기본"
			cell.filterName.textAlignment = .center
			cell.filterName.sizeToFit()
		} else {
			cell.layer.borderColor = UIColor.black.cgColor
            cell.filteredImage.image = makeFilterImage(userSelectImage: (value ?? UIImage(systemName: "star"))!, filterName: ciFilters.filter[indexPath.row-1])
			cell.filterName.text = ciFilters.filter[indexPath.row-1]
			cell.filterName.textAlignment = .center
			cell.filterName.sizeToFit()
			
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = filterCollectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
		newAddedImage.image = cell.filteredImage.image
        userFilterNum = indexPath.row
	}
	
	
}


