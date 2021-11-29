//
//  MainViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/17.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
	let identifier = "MainViewController"
	let designHelper = UIExtension()
	let filters = ciFilterNames()
	let localRealm = try! Realm()
	var tasks: Results<PolaroidCardData>!
	var imageWidth: CGFloat?
	var imageHeight: CGFloat?
	@IBOutlet weak var infoLabel: UILabel!
	var filteredImageInCell: UIImage? {
		didSet {
			imageWidth = filteredImageInCell!.size.width
			imageHeight = filteredImageInCell!.size.height
		}
	}
	
    var filterNum: Int?
	
	@IBOutlet weak var mainCollectionView: UICollectionView!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		mainCollectionView.reloadData()
		if tasks.count == 0 {
			infoLabel.text = "우측 상단 + 버튼으로 이미지를 추가하세요."
			infoLabel.textColor = UIColor.placeholderText
			infoLabel.font = designHelper.handWritingFont20
			infoLabel.textAlignment = .center
		} else {
			infoLabel.text = ""
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = designHelper.color1
		mainCollectionView.backgroundColor = designHelper.color1
		
		tasks = localRealm.objects(PolaroidCardData.self).sorted(byKeyPath: "date")
		
		navigationItem.title = "Home"
		mainCollectionView.delegate = self
		mainCollectionView.dataSource = self
		let nibName = UINib(nibName: MainCollectionViewCell.identifier, bundle: nil)
		mainCollectionView.register(nibName, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
		mainCollectionView.isPagingEnabled = true
		
		let layout = UICollectionViewFlowLayout()
		let spacing = designHelper.collectionViewSpacing
		let width = UIScreen.main.bounds.width - (2*spacing)
		let height = UIScreen.main.bounds.height * 0.75
		layout.itemSize = CGSize(width: width, height: height)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		layout.minimumLineSpacing = 2*spacing
		
		layout.scrollDirection = .horizontal
		
		mainCollectionView.collectionViewLayout = layout
		
		let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(rightButtonClicked(_:)))
		navigationItem.setRightBarButton(rightButton, animated: true)
		navigationItem.rightBarButtonItem!.tintColor = designHelper.color3
		
		navigationController?.navigationBar.barTintColor = designHelper.color1
		self.tabBarController?.tabBar.barTintColor = designHelper.color1
		self.tabBarController?.tabBar.tintColor = designHelper.color3
    }
    
	@objc func rightButtonClicked(_ sender: UIBarButtonItem) {
		let sb = UIStoryboard.init(name: "Add", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: AddViewController.identifier)
		vc.modalPresentationStyle = .fullScreen
		present(vc, animated: true, completion: nil)
	}
	
    
}
