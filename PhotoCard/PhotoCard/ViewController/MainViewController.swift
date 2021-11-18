//
//  MainViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/17.
//

import UIKit

class MainViewController: UIViewController {
	
	@IBOutlet weak var mainCollectionView: UICollectionView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		mainCollectionView.delegate = self
		mainCollectionView.dataSource = self
		let nibName = UINib(nibName: MainCollectionViewCell.identfier, bundle: nil)
		mainCollectionView.register(nibName, forCellWithReuseIdentifier: MainCollectionViewCell.identfier)
		mainCollectionView.isPagingEnabled = true
		
		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 10
		let width = UIScreen.main.bounds.width - (2*spacing)
		let height = UIScreen.main.bounds.height * 0.75
		layout.itemSize = CGSize(width: width, height: height)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		layout.minimumLineSpacing = 2*spacing
		layout.minimumInteritemSpacing = 2*spacing
		layout.scrollDirection = .horizontal
		
		mainCollectionView.collectionViewLayout = layout
		
		
		let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(rightButtonClicked(_:)))
		
		navigationItem.setRightBarButton(rightButton, animated: true)
        
    }
    
	@objc func rightButtonClicked(_ sender: UIBarButtonItem) {
		let sb = UIStoryboard.init(name: "Add", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: AddViewController.identifier)
		
		navigationController?.pushViewController(vc, animated: true)
	}
	
    
}
