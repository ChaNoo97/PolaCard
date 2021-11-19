//
//  SettingViewController.swift
//  PhotoCard
//
//  Created by Hoo's MacBookAir on 2021/11/17.
//

import UIKit

class SettingViewController: UIViewController {

	@IBOutlet weak var settingTableView: UITableView!
	override func viewDidLoad() {
        super.viewDidLoad()
		settingTableView.delegate = self
		settingTableView.dataSource = self
       
    }
    

    

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = settingTableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier) as? SettingTableViewCell else {return UITableViewCell()}
		
		return cell
	}
	
	
}


