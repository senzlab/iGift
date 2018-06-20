//
//  ChooseBackgroundViewContoller.swift
//  iGift
//
//  Created by AnujAroshA on 5/10/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class ChooseBackgroundViewContoller: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    let cellReusableIdentifier = "CellId"
    
    //    MARK: UIViewController related
    override func viewDidLoad() {
        super.viewDidLoad()
        print((#file as NSString).lastPathComponent)
        self.setupUi()
        
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReusableIdentifier)
    }
    
    //    MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: cellReusableIdentifier, for: indexPath) as UICollectionViewCell?)!
        
//        Create a circled color view inside the cell
        let colorPaletteWidth = cell.frame.size.width/2
        let colorView = UIView(frame: CGRect(x: (cell.frame.size.width/2 - colorPaletteWidth/2), y: (cell.frame.size.height/2 - colorPaletteWidth/2), width: colorPaletteWidth, height: colorPaletteWidth))
        colorView.backgroundColor = ChooseBackgroundViewModel().colourForTheCell(indexpathNumber: indexPath.row)
        colorView.layer.cornerRadius = 0.5 * colorView.bounds.size.width;
        cell.contentView.addSubview(colorView)

        cell.backgroundColor = UIColor.fromHex(0xF5944E)
        
        return cell
    }
    
    //    MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        GiftCard.shared.backgroundColor = ChooseBackgroundViewModel().colourForTheCell(indexpathNumber: indexPath.row)
        GiftCard.shared.capturedImage = nil
        self.navigationController?.popViewController(animated: false)
    }
    
    //    MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//        Minimum spacing between cells are 1.
        return CGSize(width: (colorCollectionView.frame.size.width/3) - 1, height: colorCollectionView.frame.size.height/4)
    }
    
    
    //    MARK: Supportive functions
    func setupUi() {
        self.title = "Choose background"
    }
}
