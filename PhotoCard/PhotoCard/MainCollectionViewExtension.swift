//
//  MainCollectionViewExtension.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/18.
//

import Foundation
import UIKit


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tasks.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
		let row: PolaroidCardData
		row = tasks[indexPath.row]
		
		//cell 파일로 옮기기
		cell.imageDateLabel.font = designHelper.handWritingFont20
		cell.wordingLabel.font = designHelper.handWritingFont20
		
		cell.layer.borderWidth = 3
		cell.backgroundColor = .lightGray
		
		cell.wordingLabel.backgroundColor = .orange
		cell.wordingLabel.text = row.wordingText
		
		cell.mainImageView.backgroundColor = .white
		let imageInCell = loadImageFromDocumentDirectory(imageName: "\(row._id)")
		cell.mainImageView.image = imageInCell
		
		
		cell.imageDateLabel.backgroundColor = .cyan
		cell.imageDateLabel.text = row.imageDate
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
