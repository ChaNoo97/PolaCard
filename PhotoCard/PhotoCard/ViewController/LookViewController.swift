//
//  LookViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/18.
//

import UIKit

class LookViewController: UIViewController {
	let designHelper = UIExtension()
	static let identifier = "LookViewController"
	
	@IBOutlet weak var lookCollectionView: UICollectionView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		lookCollectionView.dataSource = self
		lookCollectionView.delegate = self
		let nibName = UINib(nibName: MainCollectionViewCell.identifier, bundle: nil)
		lookCollectionView.register(nibName, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
		lookCollectionView.isPagingEnabled = true
		
		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 10
		let width = UIScreen.main.bounds.width - (2*spacing)
		let height = UIScreen.main.bounds.height * 0.75
		layout.itemSize = CGSize(width: width, height: height)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		layout.minimumLineSpacing = 2*spacing
		
		layout.scrollDirection = .horizontal
		
		lookCollectionView.collectionViewLayout = layout
       
    }
    

}

extension LookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = lookCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {return UICollectionViewCell()}
		cell.layer.borderWidth = 3
	
		cell.backgroundColor = .lightGray
		cell.mainImageView.backgroundColor = .white
		cell.mainImageView.image = UIImage(systemName: "star")
		
		cell.wordingLabel.backgroundColor = .orange
		//폰트 적용 코드
		cell.wordingLabel.font = designHelper.handWritingFont20
		cell.wordingLabel.text = "오늘은 야구장에서 별 본날"
		cell.imageDateLabel.backgroundColor = .cyan
		return cell
	}
	
	
}
