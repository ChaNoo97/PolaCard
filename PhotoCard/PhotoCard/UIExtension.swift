//
//  UIExtension.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/24.
//

import Foundation
import UIKit

class UIExtension: UIViewController {
	
	let handWritingFont20 = UIFont(name: "KyoboHandwriting2019", size: 20)
	let handWritingFont15 = UIFont(name: "KyoboHandwriting2019", size: 15)
	let collectionViewSpacing: CGFloat = 20
	let shadowRadius: CGFloat = 15
	let cornerRadius: CGFloat = 5
	
	let color0 = UIColor.init(red: 58/255, green: 119/255, blue: 190/255, alpha: 1)
	let color1 = UIColor.init(red: 250/255, green: 236/255, blue: 213/255, alpha: 1)
	let color1Light = UIColor.init(red: 253/255, green: 247/255, blue: 236/255, alpha: 1)
	let color2 = UIColor.init(red: 200/255, green: 227/255, blue: 212/255, alpha: 1)
	let color3 = UIColor.init(red: 135/255, green: 170/255, blue: 170/255, alpha: 1)
	
	func buttonDesgin(btn: UIButton, tintColor: UIColor, title: String?) {
		btn.setTitle(title, for: .normal)
		btn.tintColor = tintColor
	}
	
	func buttonLayerDesign(btn: UIButton, borderWidthValue: CGFloat, cornerRadiusValue: CGFloat,borderColor: UIColor, backgroundColor: UIColor?) {
		btn.layer.borderColor = borderColor.cgColor
		btn.layer.borderWidth = borderWidthValue
		btn.layer.cornerRadius = cornerRadiusValue
		btn.backgroundColor = backgroundColor
	}
	
	func addViewSaveButton(btn: UIButton) {
		btn.setTitle("저장하기", for: .normal)
		btn.titleLabel?.font = handWritingFont15
		btn.tintColor = color3
	}
	
}
