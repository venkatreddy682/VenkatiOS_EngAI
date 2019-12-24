//
//  Extensions.swift
//  EngineerintAITask
//
//  Created by OJAS on 12/24/19.
//  Copyright © 2019 OJAS. All rights reserved.
//

import Foundation

extension Date {
    
    func getFormatedDate(dateString : String) -> String {
        
        let formatter = DateFormatter() //2019-12-24T10:46:16.000Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let serverDate = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy-MMM-dd hh:mm a"
            let formatedDateString = formatter.string(from: serverDate)
            return formatedDateString
        }
        return dateString
    }
}
