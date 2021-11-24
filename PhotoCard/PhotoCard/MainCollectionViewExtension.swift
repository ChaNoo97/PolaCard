//
//  Main + Extension.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/18.
//

import Foundation
import UIKit


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
		cell.layer.borderWidth = 3
	
		cell.backgroundColor = .lightGray
		cell.mainImageView.backgroundColor = .white
		cell.mainImageView.image = UIImage(systemName: "star")
		
		cell.wordingLabel.backgroundColor = .orange
		cell.imageDateLabel.backgroundColor = .cyan
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print(indexPath)
		
		let sb = UIStoryboard.init(name: "Modify", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: ModifyViewController.identifier)
		//fullscreen? (11.19)
		present(vc, animated: true, completion: nil)
	}
	
}
