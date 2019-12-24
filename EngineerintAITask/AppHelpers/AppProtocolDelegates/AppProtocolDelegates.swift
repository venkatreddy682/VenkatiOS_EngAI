//
//  AppProtocolDelegates.swift
//  EngineerintAITask
//
//  Created by OJAS on 12/24/19.
//  Copyright © 2019 OJAS. All rights reserved.
//

import Foundation

@objc protocol serviceConnectorDelegate {
    func serviceConnector(didReceiveResponse response : AnyObject)
    @objc optional func serviceConnector(didFailResponse response : AnyObject)
}
