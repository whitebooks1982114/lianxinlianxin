//
//  baikeDirTableViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/13.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class baikeDirTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var list = [String]()
    
    var filterList: NSArray!
    
    var barFilterList = [String]()
    
    var searchController: UISearchController!
    
     let detailContent = detailContenViewController()
  
    
    //查询函数
    func myQuery() {
        list.removeAll()
        barFilterList.removeAll()
        let query = BmobQuery(className: "bake")
        query?.whereKey("check", equalTo: true)
        query?.limit = 1000
        query?.order(byDescending: "updatedAt")
        query?.findObjectsInBackground({ (array, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误提示", message: "服务器连接失败", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: { (act) in
                   _ = self.navigationController?.popToRootViewController(animated: true)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
          
            }else {
                for obj in array! {
                    let detail = obj as! BmobObject
                    let listtitle = detail.object(forKey: "liantitle") as! String
                    self.list.append(listtitle)
                    self.barFilterList.append(listtitle)
                    
                }
              
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        
            
        })
        self.refreshControl?.endRefreshing()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImageView(image: UIImage(named: "百科背景"))
        self.tableView.backgroundView = img
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        self.navigationItem.title = "百科目录"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.add))
     
        self.searchController.searchBar.sizeToFit()
        let op = BlockOperation {
            
            self.myQuery()
            
               
        }
        let opqueue = OperationQueue()
        opqueue.addOperation(op)
      
        
        //下拉刷新
        let myRefresh = UIRefreshControl()
        myRefresh.tintColor = UIColor.red
        myRefresh.attributedTitle = NSAttributedString(string: "刷新中")
        myRefresh.addTarget(self, action: #selector(self.myQuery), for: .valueChanged)
        self.refreshControl = myRefresh
    }
    
    
    func add() {
        
        let usr = BmobUser.current()
        if usr == nil {
            let alert  = UIAlertController(title: "温馨提示", message: "请先登录", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        self.navigationController?.pushViewController(addViewController(), animated: true)
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let seachString = searchController.searchBar.text
        self.filterContent(searchText: seachString!)
        
        print(self.filterList)
        
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.updateSearchResults(for: self.searchController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        filterContent(searchText: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.barFilterList.count
    
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)

        
        cell.textLabel?.text = self.barFilterList[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        let selectedTitle = self.list[indexPath.row]
        
        detailContent.mytitle = selectedTitle
        
     
        
        self.navigationController?.pushViewController(detailContent, animated: true)
    }
    
    func filterContent(searchText: String) {
        if searchText == "" {
            self.filterList = NSMutableArray(array: self.list)
             self.barFilterList = self.filterList as! [String]
        }else {
        
        var tempArray: NSArray?
        
        let tempArray1 = self.list as NSArray?
            
            
        let myPredicate = NSPredicate(format: "SELF contains[c] %@", searchText)
        
      
        
        tempArray = tempArray1?.filtered(using: myPredicate) as NSArray?
        
        self.filterList = NSMutableArray(array: tempArray!)
            self.barFilterList = self.filterList as! [String]
       
        
     }
    }

  }
