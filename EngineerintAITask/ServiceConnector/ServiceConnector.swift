//
//  ServiceConnector.swift
//  EngineerintAITask
//
//  Created by OJAS on 12/24/19.
//  Copyright © 2019 OJAS. All rights reserved.
//

import UIKit

class ServiceConnector: NSObject {

    var delegate : serviceConnectorDelegate?
    var superDelegate : Any?
    var serviceURLFormat = ""
    var isShowFooterIndicatorView = false
    
    func initiateServiceCall(urlString : String , params : String , httpMethod : String , delegate : Any) {
        
        self.superDelegate = delegate
        //check internet connection here
        
        if isShowFooterIndicatorView {
            isShowFooterIndicatorView = false
            DispatchQueue.main.async {
                EngSharedManager.sharedManager.hideLoader(delegate: delegate)
            }
        } else {
            EngSharedManager.sharedManager.showLoader(delegate: delegate)
        }
        
        
        if httpMethod == GET_METHOD {
            serviceURLFormat = String(format : "%@%@",urlString , params)
        }else {
            serviceURLFormat = String(format : "%@",urlString)
        }
        
        guard let url = URL(string: serviceURLFormat) else {
            return
        }
        
        let request = self.getURLRequest(url: url, httpMethod: httpMethod)
        self.dataTaskResponse(request)
    }
    
    private func getURLRequest(url : URL , httpMethod : String) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = httpMethod
        return request
    }
    
    private func dataTaskResponse(_ urlRequest : URLRequest) {
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                EngSharedManager.sharedManager.hideLoader(delegate: self.superDelegate as Any)
            }
            guard error == nil
                else {
                    self.delegate?.serviceConnector?(didFailResponse: error as AnyObject)
                    return
            }
            guard let responseDate = data
                else {
                    self.delegate?.serviceConnector?(didFailResponse: error as AnyObject)
                    return
            }
            do {
               let jsonReposneObj = try JSONSerialization.jsonObject(with: responseDate, options: [])
                self.delegate?.serviceConnector(didReceiveResponse: jsonReposneObj as AnyObject)
            }
            catch {
                print("JSON ERROR : \(error.localizedDescription)")
            }
        }.resume()
    }
}
