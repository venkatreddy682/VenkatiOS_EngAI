//
//  StoriesDataAccessLayer.swift
//  EngineerintAITask
//
//  Created by OJAS on 12/24/19.
//  Copyright © 2019 OJAS. All rights reserved.
//

import UIKit

class StoriesDataAccessLayer: ServiceConnector {

    override init() {
    }
    
    func getStoriesData(pageNo : String , delegate : Any) {
        let urlString = SERVER_BASE_URL
        let params = "tags=story&page=\(pageNo)"
        self.initiateServiceCall(urlString: urlString, params: params, httpMethod: GET_METHOD, delegate: delegate)
    }
}
