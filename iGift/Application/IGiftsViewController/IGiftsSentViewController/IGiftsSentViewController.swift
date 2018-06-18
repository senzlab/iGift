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
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    
    var dataArray: [Igift]!

    let HEIGHT_OF_ROW = 85

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            topMargin.constant = 0
        } else {
            topMargin.constant = 64
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        dataArray = SenzDb.instance.getIgifts(myGifts: true)
        
        if dataArray.count == 0 {
            tblView.isHidden = true
        }
        
        reloadTable()
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
        cell?.setAccountNo(data.account)
        cell?.lblName?.text = PhoneBook.instance.getContact(phone: data.user)?.name
        cell?.lblTime?.text = TimeUtil.sharedInstance.timeAgoSinceDate(data.timestamp/1000)
        cell?.lblAmount?.text = data.amount + ".00"
        
        cell?.selectionStyle = .none
        
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_OF_ROW)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showGiftViewController = ShowGiftViewController(nibName: "ShowGiftViewController", bundle: nil)
        showGiftViewController.iGift = dataArray[indexPath.row]
        self.navigationController?.pushViewController(showGiftViewController, animated: false)
    }
}

