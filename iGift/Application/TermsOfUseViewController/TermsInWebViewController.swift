//
//  TermsInWebViewController.swift
//  iGift
//
//  Created by AnujAroshA on 6/30/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import UIKit

class TermsInWebViewController: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    //    MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
        
        loadHtmlFile()
    }
    
    //    MARK: Supportive functions
    func setupUi() {
        self.title = "Terms of use"
        
        webView.delegate = self
        webView.isHidden = true
    }
    
    func loadHtmlFile() {
        let myProjectBundle:Bundle = Bundle.main
        let filePath:String = myProjectBundle.path(forResource: "Terms", ofType: "html")!
        let myURL = URL(string: filePath);
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        
        webView.loadRequest(myURLRequest)

    }
    
    //    MARK: UIWebViewDelegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.isHidden = false
    }
}
