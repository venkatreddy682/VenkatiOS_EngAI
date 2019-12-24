//
//  Constants.swift
//  EngineerintAITask
//
//  Created by OJAS on 12/24/19.
//  Copyright © 2019 OJAS. All rights reserved.
//

import Foundation
import UIKit

let GET_METHOD = "GET"
let POST_METHOD = "POST"
let SERVER_BASE_URL = "https://hn.algolia.com/api/v1/search_by_date?"

let NB_PAGES = "nbPages"
let HITS = "hits"

let BLACK_COLOR = UIColor.black
let GRAY_COLOR = UIColor.gray
let WHITE_COLOR = UIColor.white

let TABLECELL_SELECTION_COLOR = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1.0)

func ENG_NULL_EMPTY(_ object : AnyObject) -> AnyObject {
    
    if object is NSNull {
        return "" as AnyObject
    }
    return object
}
