//
//  RealmModel.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/24.
//

import Foundation
import RealmSwift

class PolaroidCardData: Object {
	@Persisted var wordingText: String?
	@Persisted var imageDate: String
		
	@Persisted(primaryKey: true) var _id: ObjectId
	
	convenience init(wordingText: String?, imageDate: String) {
		self.init()
		
		self.wordingText = wordingText
		self.imageDate = imageDate
	}
}
