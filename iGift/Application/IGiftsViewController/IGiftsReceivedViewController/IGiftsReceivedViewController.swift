//
//  IGiftsReceivedViewController.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/13/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class IGiftsReceivedViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!

    var dataArray = [Igift(id: 1,
                           user: "Prasad Mathugama",
                           timestamp: Int64(Date().timeIntervalSinceNow),
                           isMyIgift: true,
                           isViewed: true,
                           account: "123243545",
                           amount: "101231230 LKR"),
                     Igift(id: 1,
                           user: "Jessica Rusten",
                           timestamp: 0,
                           isMyIgift: true,
                           isViewed: true,
                           account: "58776879780",
                           amount: "10 LKR"),
                     Igift(id: 1,
                           user: "Martin Hallburg", timestamp: Int64(Date().timeIntervalSinceNow),
                           isMyIgift: false,
                           isViewed: false,
                           account: "33333333",
                           amount: "103453450 LKR")]

    let HEIGHT_OF_ROW = 85

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }

    func setupUi() {
        self.title = "iGifts"

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
        
        cell?.selectionStyle = .none

        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_ROW)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let showGiftViewController = ShowGiftViewController(nibName: "ShowGiftViewController", bundle: nil)
        self.navigationController?.pushViewController(showGiftViewController, animated: true)
    }
}


