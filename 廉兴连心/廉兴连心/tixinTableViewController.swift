//
//  tixinTableViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/17.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class tixinTableViewController: UITableViewController {
    
    
    var list = [String]()
    var deadLine = [NSDate]()
    var noticeContent = [String]()
    
    let alarmDetail = tixindetailViewController()
    
    func myQuery() {
        list.removeAll()
        let queryAlarm = BmobQuery(className: "alarm")
        
        let user = BmobUser.current()
    
        let userID = user?.objectId
        let author = BmobUser(outDataWithClassName: "_User", objectId: userID)
        queryAlarm?.whereKey("author", equalTo: author)
   
        queryAlarm?.limit = 1000
        queryAlarm?.order(byDescending: "updatedAt")
        queryAlarm?.findObjectsInBackground({ (array, error) in
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
                    let listtitle = detail.object(forKey: "alarmTitle") as! String
                    let date = detail.object(forKey: "deadLine") as! NSDate
                    let content = detail.object(forKey: "alarmContent") as! String
                    self.list.append(listtitle)
                    self.deadLine.append(date)
                    self.noticeContent.append(content)
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
        
        self.navigationItem.title = "事项提醒"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addAlarm))
        
        self.myQuery()
        
        let myRefresh = UIRefreshControl()
        myRefresh.tintColor = UIColor.red
        myRefresh.attributedTitle = NSAttributedString(string: "刷新中")
        myRefresh.addTarget(self, action: #selector(self.myQuery), for: .valueChanged)
        self.refreshControl = myRefresh
        

    }
    
        //转到添加提醒事项页面
    func addAlarm() {
        let usr = BmobUser.current()
        
        if usr == nil {
            let alert  = UIAlertController(title: "温馨提示", message: "对不起，您未登录", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else {
            
            
                
                let mystroy = self.storyboard
                let add = mystroy?.instantiateViewController(withIdentifier: "add") as! addNoticeAlarmViewController
               
                
                self.navigationController?.pushViewController(add, animated: true)
                
           
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
               return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return self.list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)

        cell.textLabel?.text = list[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        if indexPath.row <= 3 {
            cell.textLabel?.textColor = UIColor.red
        }

        

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTitle = self.list[indexPath.row]
        let selectedDate = self.deadLine[indexPath.row]
        let selectedContent = self.noticeContent[indexPath.row]
        
        alarmDetail.myTitle = selectedTitle
        alarmDetail.cutDownDate = selectedDate
        alarmDetail.alarmContent = selectedContent
        
        self.navigationController?.pushViewController(alarmDetail, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .delete
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let indexPaths = [indexPath]
        let deleteTitle = self.list[indexPath.row]
        let deleteQuery = BmobQuery(className: "alarm")
        deleteQuery?.whereKey("alarmTitle", equalTo: deleteTitle)
        deleteQuery?.findObjectsInBackground({ (array, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            }
            if array != nil {
                for obj in array! {
                    let object = obj as! BmobObject
                    let id  = object.objectId
                    
                    DispatchQueue.main.async {
                        let deleteObject = BmobObject(outDataWithClassName: "alarm", objectId: id)
                        deleteObject?.deleteInBackground({ (success, error) in
                            if success {
                                print("success")
                            }
                            if error != nil {
                                print("\(error?.localizedDescription)")
                            }
                        })
                    }
                }
            
            }
            
            
        })
        
        
        
        if editingStyle == .delete {
            self.list.remove(at: indexPath.row)
            self.deadLine.remove(at: indexPath.row)
            self.noticeContent.remove(at: indexPath.row)
            self.tableView.deleteRows(at: indexPaths, with: .fade)
            
            
            
        }
        self.tableView.reloadData()
        
    }
 

}
