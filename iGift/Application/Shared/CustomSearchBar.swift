//
//  CustomTextBox.swift
//  iGift
//
//  Created by Lakmal Caldera on 5/10/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {

    var preferredFont: UIFont = UIFont()
    var preferredTextColor: UIColor = UIColor()

    init(searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor, placeholderText: String) {
        super.init(frame: searchBarFrame)
        self.barTintColor = searchBarTintColor
        self.tintColor = searchBarTextColor
        self.preferredFont = searchBarFont
        self.preferredTextColor = searchBarTextColor
        self.showsBookmarkButton = false
        self.showsCancelButton = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.placeholder = placeholderText
        self.returnKeyType = UIReturnKeyType.done
        self.removeTextFieldClearBtn()
    }

    func removeTextFieldClearBtn() {
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = (subviews[0] ).subviews[index] as! UITextField

            // Set its frame.
            searchField.frame = CGRect(x: 5.0,y: 5.0,width: frame.size.width - 10.0,height: frame.size.height - 10.0)

            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor

            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor

            searchField.clearButtonMode = .never

            searchField.textAlignment = .left
        }
    }


    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!
        let searchBarView = self.subviews[0]

        for (i, view) in searchBarView.subviews.enumerated() {
            if  view is (UITextField) {
                index = i
                break
            }
        }

        return index
    }
}


