//
//  AddArtViewController.swift
//  iGift
//
//  Created by AnujAroshA on 5/11/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class AddArtViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var stickerCollectionView: UICollectionView!
    
    let cellReusableIdentifier = "CellId"
    
    //    MARK: UIViewController related
    override func viewDidLoad() {
        super.viewDidLoad()
        print((#file as NSString).lastPathComponent)
        self.setupUi()
        
        stickerCollectionView.dataSource = self
        stickerCollectionView.delegate = self
        stickerCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReusableIdentifier)
    }
    
    //    MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: cellReusableIdentifier, for: indexPath) as UICollectionViewCell?)!
        
        //        Create image view inside the cell
        let image = AddArtViewModel().imageForTheCell(indexpathNumber: indexPath.row)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let imageViewWidth = cell.frame.size.width/2
        imageView.frame = CGRect(x: (cell.frame.size.width/2 - imageViewWidth/2), y: (cell.frame.size.height/2 - imageViewWidth/2), width: imageViewWidth, height: imageViewWidth)
        cell.contentView.addSubview(imageView)
        
        cell.backgroundColor = UIColor.fromHex(0xF5944E)

        return cell
    }
    
    //    MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        Minimum spacing between cells are 1. Since there are two spaces like that we reduced 2 here
        return CGSize(width: (stickerCollectionView.frame.size.width - 2)/3, height: stickerCollectionView.frame.size.height/4)
    }
    
    //    MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: .tappedOnArtItem, object: nil, userInfo: [ stickerNameNotifiKey: AddArtViewModel().imageNameForTheCell(indexpathNumber: indexPath.row)])
        
        goBack(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    
    //    MARK: Supportive functions
    func setupUi() {
        self.title = "Add sticker"
    }
}
