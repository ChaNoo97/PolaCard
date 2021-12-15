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
    @Persisted var filterNum: Int
	@Persisted var date: Date
	
	@Persisted(primaryKey: true) var _id: ObjectId
	
    convenience init(wordingText: String?, imageDate: String, filterNum: Int) {
		self.init()
		
		self.wordingText = wordingText
		self.imageDate = imageDate
        self.filterNum = filterNum
	}
}

//class userAlbumData: Object {
//	@Persisted var albumName: String?
//	@Persisted var albumList: List<PolaroidCardData>
//	
//	@Persisted(primaryKey: true) var _id: ObjectId
//	
//	convenience init(albumName: String?, albumList: [PolaroidCardData]) {
//		self.init()
//		self.albumName = albumName
//		self.albumList.append(objectsIn: albumList)
//	}
//}
