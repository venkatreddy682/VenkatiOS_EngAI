//
//  EngSharedManager.swift
//  EngineerintAITask
//
//  Created by OJAS on 12/24/19.
//  Copyright © 2019 OJAS. All rights reserved.
//

import UIKit

class EngSharedManager: NSObject {

    static let sharedManager = EngSharedManager()
    
    //ACtivity indicator method footer
    func setUpTableFooterIndicator(_ object : AnyObject) -> UIView {
        let controller = object as? UIViewController
        let activityView = UIView(frame: CGRect(x: 0, y: 0, width: (controller?.view.frame.size.width)!, height: controller?.navigationController?.navigationBar.frame.size.height ?? 0))
        activityView.backgroundColor = UIColor.white
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            activityIndicator.style = .gray
        }
        activityIndicator.frame = CGRect(x: 0, y: 0, width: activityView.frame.size.width, height: 44)
        activityIndicator.startAnimating()
        activityView.addSubview(activityIndicator)
        return activityView
    }
    
    //Loader Indicator Method
    func showLoader(delegate : Any) {
        
        let vc = delegate as? UIViewController
        let alertController = UIAlertController(title: "", message: "Fetching Records", preferredStyle: .alert)
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            activityIndicator.style = .gray
        }
        activityIndicator.frame = CGRect(x: 20, y: 8, width: 40, height: 44)
        activityIndicator.startAnimating()
        alertController.view.addSubview(activityIndicator)
        vc?.present(alertController, animated: true, completion: nil)
    }
    
    func hideLoader(delegate : Any) {
        let vc = delegate as? UIViewController
        vc?.dismiss(animated: true, completion: nil)

    }
}
