//
//  MainViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/17.
//

import UIKit
import RealmSwift

//MARK: UIViewController
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
		// 처음 실행해도 오류 없음
		mainCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
		// 처음실행하면오류: 아이템이 없는데 가라고 함
//		mainCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
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
		
		self.view.backgroundColor = designHelper.viewBackgroundColor
		mainCollectionView.backgroundColor = designHelper.viewBackgroundColor
		
		tasks = localRealm.objects(PolaroidCardData.self).sorted(byKeyPath: "date", ascending: false)
		
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
		navigationItem.rightBarButtonItem!.tintColor = designHelper.buttonTintColor
		
		navigationController?.navigationBar.barTintColor = designHelper.viewBackgroundColor
		self.tabBarController?.tabBar.barTintColor = designHelper.viewBackgroundColor
		self.tabBarController?.tabBar.tintColor = designHelper.buttonTintColor
    }
    
	@objc func rightButtonClicked(_ sender: UIBarButtonItem) {
		let sb = UIStoryboard.init(name: "Add", bundle: nil)
		let vc = sb.instantiateViewController(withIdentifier: AddViewController.identifier)
		vc.modalPresentationStyle = .fullScreen
		present(vc, animated: true, completion: nil)
	}
	
    
}

//MARK: MainCollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tasks.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
		
		cell.layer.cornerRadius = designHelper.cornerRadius
		cell.backView.layer.cornerRadius = designHelper.cornerRadius
		cell.backView.backgroundColor = designHelper.cardBackgroundColor
		
		let row: PolaroidCardData
		row = tasks[indexPath.row]

		//cell 파일로 옮기기
		cell.imageDateLabel.font = designHelper.handWritingFont20
		cell.wordingLabel.font = designHelper.handWritingFont20
		if let cnt = row.wordingText?.count {
			if cnt > 27 {
				cell.wordingLabel.font = designHelper.handWritingFont13
			} else if cnt > 16 {
				cell.wordingLabel.font = designHelper.handWritingFont15
			} else {
				cell.wordingLabel.font = designHelper.handWritingFont20
			}
		}
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
