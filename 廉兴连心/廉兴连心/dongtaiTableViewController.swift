//
//  dongtaiTableViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/17.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class dongtaiTableViewController: UITableViewController {
    
    var list  = [String]()
    var levelList = [String]()
    
    let newsDetail = newsdetailViewController()
    
    
    //查询函数
    func myQuery() {
        list.removeAll()
        levelList.removeAll()
        let query = BmobQuery(className: "news")
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
                    let listtitle = detail.object(forKey: "title") as! String
                    let level = detail.object(forKey: "level") as! String
                    self.list.append(listtitle)
                    self.levelList.append(level)
                 
                    
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

              self.tableView.backgroundView = UIImageView(image: UIImage(named: "通知背景"))
        self.navigationItem.title = "要闻动态"
 
        
        //下拉刷新
        let myRefresh = UIRefreshControl()
        myRefresh.tintColor = UIColor.red
        myRefresh.attributedTitle = NSAttributedString(string: "刷新中")
        myRefresh.addTarget(self, action: #selector(self.myQuery), for: .valueChanged)
        self.refreshControl = myRefresh

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        myQuery()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
                return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return self.list.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)

        cell.textLabel?.text = self.list[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        switch levelList[indexPath.row] {
        case "中央":
            cell.textLabel?.textColor = UIColor.red
        case "国网":
            cell.textLabel?.textColor = UIColor.green
        case "上海":
            cell.textLabel?.textColor = UIColor.magenta
        default:
            cell.textLabel?.textColor = UIColor.brown
        }
        

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTitle = self.list[indexPath.row]
       
        newsDetail.newsName = selectedTitle
        
        self.navigationController?.pushViewController(newsDetail, animated: true)
        
    }
    
    
}
