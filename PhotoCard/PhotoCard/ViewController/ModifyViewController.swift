//
//  ModifyViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/18.
//

import UIKit
import RealmSwift

class ModifyViewController: UIViewController, UITextFieldDelegate {
	
	static let identifier = "ModifyViewController"
	
	@IBOutlet weak var modifyImageView: UIImageView!
	@IBOutlet weak var modifyWordingTextField: UITextField!
	@IBOutlet weak var saveDateLabel: UILabel!
	@IBOutlet weak var polaroidCardView: UIView!
	@IBOutlet weak var modifyCollectionView: UICollectionView!
	
	let localRealm = try! Realm()
	let designHelper = UIExtension()
	let filters = ciFilterNames()
	var modifyCard: PolaroidCardData?
	var loadImage: UIImage?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.tabBarController?.tabBar.isHidden = true
		self.tabBarController?.tabBar.isTranslucent = true
		
		let save = UIBarButtonItem(title: "저장하기", style: .plain, target: self, action: #selector(saveTapped))
		let share = UIBarButtonItem(title: "공유하기", style: .plain, target: self, action: #selector(shareTapped))
		navigationItem.rightBarButtonItems = [save, share]
		
		self.view.backgroundColor = designHelper.viewBackgroundColor
		modifyImageView.backgroundColor = designHelper.cardBackgroundColor
		polaroidCardView.backgroundColor = designHelper.cardBackgroundColor
		saveDateLabel.backgroundColor = designHelper.cardBackgroundColor
		modifyWordingTextField.backgroundColor = designHelper.cardBackgroundColor
		
		modifyCollectionView.delegate = self
		modifyCollectionView.dataSource = self
		let nibName = UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil)
		modifyCollectionView.register(nibName, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)

		polaroidCardView.layer.cornerRadius = designHelper.cornerRadius
		polaroidCardView.layer.masksToBounds = false
		polaroidCardView.layer.shadowOpacity = 0.3
		polaroidCardView.layer.shadowOffset = CGSize(width: 10, height: 2)
		polaroidCardView.layer.shadowRadius = designHelper.shadowRadius
		
		modifyWordingTextField.borderStyle = .none
		modifyWordingTextField.delegate = self
		
		guard let modifyCard = modifyCard else {return}
		loadImage = loadImageFromDocumentDirectory(imageName: "\(modifyCard._id)")
		let filterNum = modifyCard.filterNum
		if filterNum == 0 {
			modifyImageView.image = loadImage!
		} else {
			let filterImage = makeFilterImage(userSelectImage: loadImage!, filterName: filters.filter[filterNum-1])
			modifyImageView.image = filterImage!
		}
		modifyWordingTextField.font = designHelper.handWritingFont20
		if modifyCard.wordingText == "" {
			modifyWordingTextField.placeholder = "사진의 경험을 적어주세요(25자 이내)"
		} else {
			modifyWordingTextField.text = modifyCard.wordingText
		}
		
		saveDateLabel.text = modifyCard.imageDate
		saveDateLabel.font = designHelper.handWritingFont20
		saveDateLabel.textAlignment = .right
		
		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 10
		layout.itemSize = CGSize(width: 70, height: 70)
		layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		layout.minimumLineSpacing = 2*spacing

		layout.scrollDirection = .horizontal
		
		modifyCollectionView.collectionViewLayout = layout
		
		modifyCollectionView.layer.cornerRadius = designHelper.cornerRadius
		modifyCollectionView.backgroundColor = designHelper.viewBackgroundColor
		
    }
	
	func textFieldDidChangeSelection(_ textField: UITextField) {
		designHelper.checkMaxLenght(textField: modifyWordingTextField, maxLenght: 25)
	}
	
	@objc func saveTapped(_ sender: UIBarButtonItem) {
		
		let actionSheet = UIAlertController(title: nil, message: "수정/삭제", preferredStyle: .actionSheet)

		let modify = UIAlertAction(title: "수정", style: .default) { action in

			try! self.localRealm.write {
				self.modifyCard?.wordingText = self.modifyWordingTextField.text
			}
			self.navigationController?.popViewController(animated: true)
		}
		let delete = UIAlertAction(title: "삭제", style: .destructive) { action in

			let alert = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)

			let destructive = UIAlertAction(title: "삭제", style: .destructive) { action in
				self.deleteImageToDocumentDirectory(imageName: "\(self.modifyCard!._id).png")
				try! self.localRealm.write {
					self.localRealm.delete(self.modifyCard!)
					self.navigationController?.popViewController(animated: true)
				}
			}
			let cancle = UIAlertAction(title: "취소", style: .cancel) { action in

			}

			alert.addAction(destructive)
			alert.addAction(cancle)

			self.present(alert, animated: true, completion: nil)
		}
		let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

		actionSheet.addAction(modify)
		actionSheet.addAction(delete)
		actionSheet.addAction(cancel)

		present(actionSheet, animated: true, completion: nil)
	}

	@objc func shareTapped(_ sender: UIBarButtonItem) {
		let renderUIImage = sharePolaCard(sharingView: polaroidCardView)
		
		let vc = UIActivityViewController(activityItems: [renderUIImage], applicationActivities: nil)
		vc.excludedActivityTypes = [.saveToCameraRoll]
		present(vc, animated: true, completion: nil)
		print(#function)
	}
}

extension ModifyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filters.filter.count+1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = modifyCollectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
		
		cell.layer.cornerRadius = designHelper.cornerRadius
		cell.layer.borderWidth = 2
		cell.layer.borderColor = designHelper.buttonTintColor.cgColor
		
		if indexPath.item == modifyCard!.filterNum {
			cell.isSelected = true
			modifyCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
		}
		
		if indexPath.row == 0 {
			cell.filteredImage.image = loadImage
			cell.filterName.text = "원본"
			cell.filterName.font = designHelper.handWritingFont15
			cell.filterName.textAlignment = .center
			cell.filterName.sizeToFit()
		} else {
			cell.filteredImage.image = makeFilterImage(userSelectImage: (loadImage ?? UIImage(systemName: "star"))!, filterName: filters.filter[indexPath.row-1])
			cell.filterName.text = filters.filterKor[indexPath.row-1]
			cell.filterName.font = designHelper.handWritingFont15
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


