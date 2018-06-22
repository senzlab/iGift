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
        
        tblView.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        dataArray = SenzDb.instance.getIgifts(myGifts: false)
        
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
        if data.state == "TRANSFER" {
            cell?.setRedeem()
        } else {
            cell?.setAccountNo(data.account)
        }
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
    
    //    MARK : Pull to refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.orange
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // refresh phone book
        //SenzProgressView.shared.showProgressView((self.navigationController?.view)!)
        //fetch()
    }
    
    func fetch() {
        // download image
        DispatchQueue.main.async {
            let zs = Httpz.instance.pushSenz(senz: SenzUtil.instance.fetchSenz())
            if zs != nil {
                // fetch done
                // split and parse
                for z in zs!.components(separatedBy: ";") {
                    if !z.isEmpty {
                        let senz = SenzUtil.instance.parse(msg: z)
                        
                        // create new iGift
                        let senzGift = Igift(id: 1)
                        senzGift.uid = senz.attr["#uid"]!
                        senzGift.user = senz.attr["#from"]!
                        senzGift.amount = senz.attr["#amnt"]!
                        senzGift.cid = senz.attr["#id"]!
                        senzGift.state = "TRANSFER"
                        senzGift.timestamp = TimeUtil.sharedInstance.timestamp()
                        senzGift.isMyIgift = false
                        senzGift.isViewed = false
                        _ = SenzDb.instance.createIgift(igift: senzGift)
                    }
                }
                
                // reload list
                self.dataArray = SenzDb.instance.getIgifts(myGifts: false)
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    self.refreshControl.endRefreshing()
                    //SenzProgressView.shared.hideProgressView()
                }
            }
        }
    }
    
}


