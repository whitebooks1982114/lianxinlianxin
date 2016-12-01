//
//  tongziTableViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/17.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit



class tongziTableViewController: UITableViewController {
    
  
    
    var list = [String]()
    var deadLine = [NSDate]()
    var noticeContent = [String]()
    
    let noticeDetail = noticedetailViewController()
    

    func myQuery() {
        list.removeAll()
        let queryNotice = BmobQuery(className: "notice")
        let noticeInQuery = BmobUser.query()
        let user = BmobUser.current()
        let userName = user?.username
        noticeInQuery?.whereKey("username", equalTo: userName)
        queryNotice?.whereKey("relation", matchesQuery: noticeInQuery)
        queryNotice?.limit = 1000
        queryNotice?.order(byDescending: "updatedAt")
        queryNotice?.findObjectsInBackground({ (array, error) in
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
                    let date = detail.object(forKey: "deadline") as! NSDate
                    let content = detail.object(forKey: "content") as! String
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "通知背景"))
        self.navigationItem.title = "消息通知"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNotice))
        //如果未登录，通知列表无数据
      let user = BmobUser.current()
        if user == nil {
            list.removeAll()
            
        }else {
        
        self.myQuery()
        
        let myRefresh = UIRefreshControl()
        myRefresh.tintColor = UIColor.red
        myRefresh.attributedTitle = NSAttributedString(string: "刷新中")
        myRefresh.addTarget(self, action: #selector(self.myQuery), for: .valueChanged)
        self.refreshControl = myRefresh

        }
        
        
        
    }
    
    //转到添加通知页面
    func addNotice()  {
        
        let usr = BmobUser.current()
        if usr == nil{
            let alert  = UIAlertController(title: "温馨提示", message: "对不起，您未登录", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else {
            
            let userName = usr?.object(forKey: "username")
            let currentUser = userName as! String
            
            if currentUser == "whitebooks" {
                
                let add = self.storyboard?.instantiateViewController(withIdentifier: "add") as! addNoticeAlarmViewController
                
                self.navigationController?.pushViewController(add, animated: true)
                
            }else {
                let alert  = UIAlertController(title: "温馨提示", message: "对不起，您的权限不足", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        
        noticeDetail.mytitle = selectedTitle
        noticeDetail.cutDownTime = selectedDate
        noticeDetail.myNoticeContent = selectedContent
        
        self.navigationController?.pushViewController(noticeDetail, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
