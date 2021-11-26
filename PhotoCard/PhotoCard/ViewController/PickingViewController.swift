//
//  PickingViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/18.
//

import UIKit

class PickingViewController: UIViewController {
	
	static let identifier = "PickingViewController"
	
	@IBOutlet weak var pickingCollectionView: UICollectionView!
	@IBOutlet weak var backButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		pickingCollectionView.dataSource = self
		pickingCollectionView.delegate = self
		let nibName = UINib(nibName: MainCollectionViewCell.identifier, bundle: nil)
		pickingCollectionView.register(nibName, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
		pickingCollectionView.isPagingEnabled = true
		
		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 10
		let width = UIScreen.main.bounds.width - (2*spacing)
		let height = UIScreen.main.bounds.height * 0.8
		layout.itemSize = CGSize(width: width, height: height)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		layout.minimumLineSpacing = 2*spacing
		
		layout.scrollDirection = .horizontal
		
		pickingCollectionView.collectionViewLayout = layout
        
    }
    
	@IBAction func backButtonClicked(_ sender: UIButton) {
		dismiss(animated: true)
	}
	
   

}

extension PickingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = pickingCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}
		cell.layer.borderWidth = 3
	
		cell.backgroundColor = .lightGray
		cell.mainImageView.backgroundColor = .white
		cell.mainImageView.image = UIImage(systemName: "star")
		
		cell.wordingLabel.backgroundColor = .orange
		cell.imageDateLabel.backgroundColor = .cyan
		return cell
	}
	
	
}
