//
//  ModifyViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/18.
//

import UIKit
import RealmSwift

class ModifyViewController: UIViewController {
	
	static let identifier = "ModifyViewController"
	
	@IBOutlet weak var modifyImageView: UIImageView!
	@IBOutlet weak var modifyWordingTextField: UITextField!
	@IBOutlet weak var saveDateLabel: UILabel!
	@IBOutlet weak var modifyButton: UIButton!
	@IBOutlet weak var modifyCollectionView: UICollectionView!
	
	let localRealm = try! Realm()
	let designHelper = UIExtension()
	let filters = ciFilterNames()
	var modifyCard: PolaroidCardData?
	var loadImage: UIImage?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		modifyCollectionView.delegate = self
		modifyCollectionView.dataSource = self
		let nibName = UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil)
		modifyCollectionView.register(nibName, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
		
		guard let modifyCard = modifyCard else {
			return
		}
		loadImage = loadImageFromDocumentDirectory(imageName: "\(modifyCard._id)")
		let filterNum = modifyCard.filterNum
		if filterNum == 0 {
			modifyImageView.image = loadImage!
		} else {
			let filterImage = makeFilterImage(userSelectImage: loadImage!, filterName: filters.filter[filterNum-1])
			modifyImageView.image = filterImage!
		}
		
		if modifyCard.wordingText == "" {
			modifyWordingTextField.placeholder = "사진의 경험을 적어주세요"
		} else {
			modifyWordingTextField.text = modifyCard.wordingText
			modifyWordingTextField.font = designHelper.handWritingFont20
		}
		
		saveDateLabel.text = modifyCard.imageDate
		saveDateLabel.font = designHelper.handWritingFont20
		designHelper.buttonDesgin(btn: modifyButton, tintColor: .black, title: "수정하기")
		designHelper.buttonLayerDesign(btn: modifyButton, borderWidthValue: 1, cornerRadiusValue: designHelper.cornerRadius, borderColor: .black, backgroundColor: .white)
		
		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 10
		let cellHeight = modifyCollectionView.bounds.height
		layout.itemSize = CGSize(width: cellHeight, height: cellHeight)
		let sideEdgeInset:CGFloat = cellHeight*CGFloat((filters.filter.count+1))-cellHeight/2
		layout.sectionInset = UIEdgeInsets(top: 1, left: sideEdgeInset, bottom: 1, right: sideEdgeInset)
		layout.minimumLineSpacing = 2*spacing
		
		layout.scrollDirection = .horizontal
		
		modifyCollectionView.collectionViewLayout = layout
		
		modifyCollectionView.layer.cornerRadius = designHelper.cornerRadius
		modifyCollectionView.backgroundColor = .systemGray5
		
    }

	@IBAction func modifyButtonClicked(_ sender: UIButton) {
		
	}
	
}

extension ModifyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filters.filter.count+1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = modifyCollectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
		
		cell.layer.borderWidth = 1
		
		modifyCollectionView.selectItem(at: IndexPath.init(row: modifyCard!.filterNum, section: 0), animated: true, scrollPosition: .init())
		
		if indexPath.row == 0 {
			cell.filteredImage.image = loadImage
			cell.filterName.text = "기본"
			cell.filterName.textAlignment = .center
			cell.filterName.sizeToFit()
		} else {
			cell.layer.borderColor = UIColor.black.cgColor
			cell.filteredImage.image = makeFilterImage(userSelectImage: (loadImage ?? UIImage(systemName: "star"))!, filterName: filters.filter[indexPath.row-1])
			cell.filterName.text = filters.filter[indexPath.row-1]
			cell.filterName.textAlignment = .center
			cell.filterName.sizeToFit()
			
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = modifyCollectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
		modifyImageView.image = cell.filteredImage.image
		try! localRealm.write {
			modifyCard?.filterNum = indexPath.row
		}
	}
	
}
