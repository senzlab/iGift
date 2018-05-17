//
//  IGiftsSentViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/13/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class IGiftsSentViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!

    var dataArray: [Igift]!
    
//    var dataArray = [Igift(id: 1,
//                           user: "Lamda Lakmal",
//                           timestamp: 0,
//                           isMyIgift: true,
//                           isViewed: true,
//                           account: "54321",
//                           amount: "100 LKR"),
//                     Igift(id: 1,
//                           user: "Haskeller Eranga",
//                           timestamp: 0,
//                           isMyIgift: true,
//                           isViewed: false,
//                           account: "1232232212343",
//                           amount: "100 LKR"),
//                    Igift(id: 1,
//                           user: "Nalla Hewage", timestamp: 0,
//                           isMyIgift: false,
//                           isViewed: true,
//                           account: "54321",
//                           amount: "100 LKR")]

    let HEIGHT_OF_ROW = 85

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        dataArray = SenzDb.instance.getIgifts(myGifts: false)
    }

    func setupUi() {
        self.title = "Sent"

    }

    func reloadTable() {
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }

    // MARK: UITableView Delegate Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Try to find reusable cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomIGiftCell") as? CustomIGiftCell

        // If not available instantiate new custom cell
        if (cell == nil) {
            var nibArray = NSArray()
            nibArray = Bundle.main.loadNibNamed("CustomIGiftCell", owner: self, options: nil)! as NSArray
            cell = nibArray.object(at: 0) as? CustomIGiftCell
        }

        let data = dataArray[indexPath.row]

        // Set if redeemed show button if not show account ??
        if data.isViewed {
            cell?.setRedeem()
        } else {
            cell?.setAccountNo(data.account)
        }

        cell?.lblName?.text = data.user
        cell?.lblTime?.text = TimeUtil.sharedInstance.timeAgoSinceDate(data.timestamp)
        cell?.lblAmount?.text = data.amount

        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_ROW)
    }
}

