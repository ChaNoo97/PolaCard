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
		
		cell.layer.cornerRadius = designHelper.cornerRadius
		cell.backView.layer.cornerRadius = designHelper.cornerRadius
		cell.backView.backgroundColor = designHelper.color1Light
		
		let row: PolaroidCardData
		row = tasks[indexPath.row]

		//cell 파일로 옮기기
		cell.imageDateLabel.font = designHelper.handWritingFont20
		cell.wordingLabel.font = designHelper.handWritingFont20
		
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
		
		cell.layer.masksToBounds = false
		cell.layer.shadowOpacity = 0.3
		cell.layer.shadowOffset = CGSize(width: 10, height: 2)
		cell.layer.shadowRadius = designHelper.shadowRadius

		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {		
		let sb = UIStoryboard.init(name: "Modify", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: ModifyViewController.identifier) as! ModifyViewController
		vc.modalPresentationStyle = .fullScreen
		vc.modifyCard = tasks[indexPath.row]
		present(vc, animated: true, completion: nil)
	}
	
}
