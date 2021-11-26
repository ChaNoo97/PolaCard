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
		
		cell.wordingLabel.text = row.wordingText
		
		
        filterNum = row.filterNum
        let imageInCell = self.loadImageFromDocumentDirectory(imageName: "\(row._id)")
        
		DispatchQueue.main.async {
            if self.filterNum == 0 {
                cell.mainImageView.image = imageInCell
            } else {
            self.filteredImageInCell = self.makeFilterImage(userSelectImage: imageInCell!, filterName: self.filters.filter[self.filterNum!-1])!
                cell.mainImageView.image = self.filteredImageInCell
            }
		}
	
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
