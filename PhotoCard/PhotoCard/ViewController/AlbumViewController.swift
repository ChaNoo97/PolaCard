//
//  AlbumViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/17.
//

import UIKit

class AlbumViewController: UIViewController {
	
	@IBOutlet weak var albumCollectionView: UICollectionView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = "Album"
		albumCollectionView.delegate = self
		albumCollectionView.dataSource = self
		let nibName = UINib(nibName: AlbumCollectionViewCell.identifier, bundle: nil)
		albumCollectionView.register(nibName, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
		
        let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 10
		let width = UIScreen.main.bounds.width - (3*spacing)
		let height = UIScreen.main.bounds.height * 0.75 - (3*spacing)
		layout.itemSize = CGSize(width: width/2, height: height/2)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		layout.minimumLineSpacing = spacing
		layout.scrollDirection = .vertical
		
		albumCollectionView.collectionViewLayout = layout
    }
    

   

}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 8
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = albumCollectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
		
		cell.firstImageView.backgroundColor = .blue
		cell.albumNameLabel.backgroundColor = .orange
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		//indexPath.row 가 numOfItemSection 배열의 마지막일때 -> picking
		//나머지는 Look
		if indexPath.row == 0 {
			let sb = UIStoryboard.init(name: "Look", bundle: nil)
			let vc = sb.instantiateViewController(withIdentifier: "LookViewController")
			navigationController?.pushViewController(vc, animated: true)
		} else {
			let sb = UIStoryboard.init(name: "Picking", bundle: nil)
			let vc = sb.instantiateViewController(withIdentifier: "PickingViewController")
			vc.modalPresentationStyle = .fullScreen
			present(vc, animated: true, completion: nil)
		}
		
	}
	
	
}
