//
//  StoriesViewController.swift
//  EngineerintAITask
//
//  Created by OJAS on 12/24/19.
//  Copyright © 2019 OJAS. All rights reserved.
//

import UIKit

class StoriesViewController: UIViewController {

    @IBOutlet weak var tableview_stories : UITableView!
    var storiesDataAccesslayer = StoriesDataAccessLayer()
    var currentPage = 1
    var totalPages = 0
    var tableListingArray = NSMutableArray()
    var dataInfoArray = NSMutableArray()
    var selectedPostsArray = NSMutableArray()
    var refreshControl = UIRefreshControl()
    
    //MARK:- VIEWDIDLOAD METHOD

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableview
        tableview_stories.delegate = self
        tableview_stories.dataSource = self
        tableview_stories.estimatedRowHeight = 100
        tableview_stories.rowHeight =  UITableView.automaticDimension
        tableview_stories.tableFooterView = UIView()
        
        //set stories dataAccesslayer delegate
        storiesDataAccesslayer.delegate = self
        
        //initially post selection count will be zero
        self.displaySelectedPostCount(selectedCount: 0)
        
        //pull to refresh
        refreshControl.addTarget(self, action: #selector(refreshStoriesData(_:)), for: .valueChanged)
        tableview_stories.addSubview(refreshControl)
    }
    
    //MARK:- VIEWDIDAPPEAR METHOD

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.callStoriesWebService(pageNo: currentPage)
    }
}

//MARK:- CUSTOM METHODS

extension StoriesViewController {
    
    private func callStoriesWebService(pageNo : Int) {
        storiesDataAccesslayer.getStoriesData(pageNo: String(pageNo), delegate: self)
    }
    
    private func reloadTableData() {
        DispatchQueue.main.async {
            self.tableview_stories.reloadData()
        }
    }
    
    private func loadMoreData() {
        currentPage = currentPage + 1
        self.callStoriesWebService(pageNo: currentPage)
    }
    
    private func displaySelectedPostCount(selectedCount : Int) {
        self.navigationItem.title = "Selected Posts : \(selectedCount)"
    }
    
    @objc func refreshStoriesData(_ sender : Any) {
        self.clearAllData()
        storiesDataAccesslayer.isShowFooterIndicatorView = true
        self.callStoriesWebService(pageNo: currentPage)
    }
    
    private func clearAllData() {
        //set cuurent page to 1
        currentPage = 1
        //delete data from all arrays
        if dataInfoArray.count > 0 {
            dataInfoArray.removeAllObjects()
        }
        if tableListingArray.count > 0 {
            tableListingArray.removeAllObjects()
        }
        if selectedPostsArray.count > 0 {
            selectedPostsArray.removeAllObjects()
        }
        self.displaySelectedPostCount(selectedCount: 0)
    }
    
    private func stopRefreshing() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
}

//MARK:- UITABLEVIEW DELEGATE AND DATASOURCE METHODS
extension StoriesViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableListingArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "StoriesCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? StoriesCell
        if cell == nil {
           let arrNib = Bundle.main.loadNibNamed(cellIdentifier, owner: self, options: nil)
            cell = arrNib?.first as? StoriesCell
        }
        cell?.selectionStyle = .none
        cell?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if tableListingArray.count > indexPath.row {
            if tableListingArray.count > 0 , let dict = tableListingArray[indexPath.row] as? NSDictionary {
                cell?.setStoriesData(data: dict, indexpath: indexPath, delegate: self)
                if selectedPostsArray.contains(dict) {
                    cell?.switch_toggle.isOn = true
                    cell?.contentView.backgroundColor = TABLECELL_SELECTION_COLOR
                } else {
                    cell?.switch_toggle.isOn = false
                    cell?.contentView.backgroundColor = WHITE_COLOR
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? StoriesCell
        
        if let dict = tableListingArray[indexPath.row] as? NSDictionary {
            if selectedPostsArray.contains(dict) {
                selectedPostsArray.remove(dict)
                cell?.switch_toggle.isOn = false
                cell?.contentView.backgroundColor = WHITE_COLOR
            } else {
                selectedPostsArray.add(dict)
                cell?.switch_toggle.isOn = true
                cell?.contentView.backgroundColor = TABLECELL_SELECTION_COLOR
            }
            self.displaySelectedPostCount(selectedCount: selectedPostsArray.count)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == tableListingArray.count - 1 { //last row
            if self.currentPage < self.totalPages - 1 { //more records to fetch
               let footerView = EngSharedManager.sharedManager.setUpTableFooterIndicator(self)
                tableview_stories.tableFooterView = footerView
                storiesDataAccesslayer.isShowFooterIndicatorView = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.loadMoreData()
                }
            } else { //no records
                tableview_stories.tableFooterView = nil
                storiesDataAccesslayer.isShowFooterIndicatorView = false
            }
        }
    }
}

//MARK:- SERVICE CONNECTOR DELEGATE METHODS
extension StoriesViewController : serviceConnectorDelegate {
    
    func serviceConnector(didReceiveResponse response: AnyObject) {
        self.stopRefreshing()
        if response is NSDictionary , let resposneDict = response as? NSDictionary {
            
           // print(resposneDict)
            //get total pages count
            if let allPagesCount = ENG_NULL_EMPTY(resposneDict.object(forKey: NB_PAGES) as AnyObject) as? Int {
                totalPages = allPagesCount
            }
            
            //get stories array here
            if resposneDict.object(forKey: HITS) is NSArray , let hitsArray = resposneDict.object(forKey: HITS) as? NSArray , hitsArray.count > 0 {
                
                dataInfoArray.addObjects(from: hitsArray as! [Any])
                if dataInfoArray.count > 0 {
                    tableListingArray = NSMutableArray(array: dataInfoArray).mutableCopy() as! NSMutableArray
                }
            }
            //reload table
            self.reloadTableData()
        }
    }
    func serviceConnector(didFailResponse response : AnyObject) {
       // print(response)
    }
}
