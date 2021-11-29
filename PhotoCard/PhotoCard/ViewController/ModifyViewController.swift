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
	@IBOutlet weak var polaroidCardView: UIView!
	@IBOutlet weak var modifyButton: UIButton!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var modifyCollectionView: UICollectionView!
	
	let localRealm = try! Realm()
	let designHelper = UIExtension()
	let filters = ciFilterNames()
	var modifyCard: PolaroidCardData?
	var loadImage: UIImage?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = designHelper.color1
		modifyImageView.backgroundColor = designHelper.color1Light
		polaroidCardView.backgroundColor = designHelper.color1Light
		saveDateLabel.backgroundColor = designHelper.color1Light
		modifyWordingTextField.backgroundColor = designHelper.color1Light
		
		modifyCollectionView.delegate = self
		modifyCollectionView.dataSource = self
		let nibName = UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil)
		modifyCollectionView.register(nibName, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
		
		polaroidCardView.layer.cornerRadius = designHelper.cornerRadius
		polaroidCardView.layer.masksToBounds = false
		polaroidCardView.layer.shadowOpacity = 0.3
		polaroidCardView.layer.shadowOffset = CGSize(width: 10, height: 2)
		polaroidCardView.layer.shadowRadius = designHelper.shadowRadius
		
		guard let modifyCard = modifyCard else {return}
		loadImage = loadImageFromDocumentDirectory(imageName: "\(modifyCard._id)")
		let filterNum = modifyCard.filterNum
		if filterNum == 0 {
			modifyImageView.image = loadImage!
		} else {
			let filterImage = makeFilterImage(userSelectImage: loadImage!, filterName: filters.filter[filterNum-1])
			modifyImageView.image = filterImage!
		}
		modifyWordingTextField.font = designHelper.handWritingFont15
		if modifyCard.wordingText == "" {
			modifyWordingTextField.placeholder = "사진의 경험을 적어주세요"
		} else {
			modifyWordingTextField.text = modifyCard.wordingText
		}
		
		saveDateLabel.text = modifyCard.imageDate
		saveDateLabel.font = designHelper.handWritingFont20
		saveDateLabel.textAlignment = .right
		designHelper.buttonDesgin(btn: modifyButton, tintColor: .black, title: "수정하기")
		modifyButton.titleLabel?.font = designHelper.handWritingFont15
		designHelper.buttonLayerDesign(btn: modifyButton, borderWidthValue: 1, cornerRadiusValue: designHelper.cornerRadius, borderColor: .black, backgroundColor: nil)
		designHelper.buttonDesgin(btn: backButton, tintColor: .black, title: "뒤로가기")
		backButton.titleLabel?.font = designHelper.handWritingFont15
		designHelper.buttonLayerDesign(btn: backButton, borderWidthValue: 1, cornerRadiusValue: designHelper.cornerRadius, borderColor: .black, backgroundColor: nil)
		
		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 10
		layout.itemSize = CGSize(width: 50, height: 50)
		let sideEdgeInset:CGFloat = 50*CGFloat((filters.filter.count+1))-50/2
		layout.sectionInset = UIEdgeInsets(top: 5, left: sideEdgeInset, bottom: 5, right: sideEdgeInset)
		layout.minimumLineSpacing = 2*spacing
		
		layout.scrollDirection = .horizontal
		
		modifyCollectionView.collectionViewLayout = layout
		
		modifyCollectionView.layer.cornerRadius = designHelper.cornerRadius
		modifyCollectionView.backgroundColor = .systemGray5
		
    }

	@IBAction func backButtonClicked(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func modifyButtonClicked(_ sender: UIButton) {
		
		try! localRealm.write {
			modifyCard?.wordingText = modifyWordingTextField.text
		}
		
		let alert = UIAlertController(title: nil, message: "eng", preferredStyle: .alert)
		
		let confirm = UIAlertAction(title: "확인", style: .default) { action in
			self.dismiss(animated: true, completion: nil)
		}
		
		alert.addAction(confirm)
		
		present(alert, animated: true, completion: nil)
	}
	
}

extension ModifyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filters.filter.count+1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = modifyCollectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
		
		cell.layer.borderWidth = 1
		print(modifyCard!.filterNum)
		
		modifyCollectionView.selectItem(at: IndexPath.init(row: 2, section: 0), animated: true, scrollPosition: .init())
		
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
		print(indexPath)
		let cell = modifyCollectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
		modifyImageView.image = cell.filteredImage.image
		cell.layer.borderColor = designHelper.color3.cgColor
		try! localRealm.write {
			modifyCard?.filterNum = indexPath.row
		}
	}
	
}
