////
////  UITextView.swift
////  iGift
////
////  Created by Isuru_Jayathissa on 5/17/18.
////  Copyright © 2018 Creative Solutions. All rights reserved.
////
//
//import UIKit
//
//extension UITextView {
//    @IBInspectable var align_middle_vertical: Bool {
//        get {
//            return false    //  TODO
//        }
//        set (f) {
//            self.addObserver(self, forKeyPath:"contentSize", options:.new, context:nil)
//        }
//    }
//    public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject:AnyObject], context: UnsafeMutableRawPointer) {
//        if let textView = object as? UITextView {
//            var y: CGFloat = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale)/2.0;
//            if y < 0 {
//                y = 0
//            }
//            textView.content_y = -y
//        }
//    }
//}
//
//public extension UIScrollView {
//    public var content_x: CGFloat {
//        set(f) {
//            contentOffset.x = f
//        }
//        get {
//            return contentOffset.x
//        }
//    }
//    public var content_y: CGFloat {
//        set(f) {
//            contentOffset.y = f
//        }
//        get {
//            return contentOffset.y
//        }
//    }
//}

