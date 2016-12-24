//
//  MailBoxTableViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/24.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class MailBoxTableViewController: UITableViewController {
    
    var list = [String]()
    var readedList = [Bool]()
    
    let detailContent = DetailReplyContentViewController()
    
   
    
    
    //查询函数
    func myQuery() {
        list.removeAll()
        let query = BmobQuery(className: "report")
        
        let user = BmobUser.current()
        
        let userID = user?.objectId
        let author = BmobUser(outDataWithClassName: "_User", objectId: userID)
        query?.whereKey("author", equalTo: author)
        
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
                    let listtitle = detail.object(forKey: "replytitle") as? String
                    let readed = detail.object(forKey: "readed") as? Bool
                    if listtitle != nil {
                        self.list.append(listtitle!)
                        self.readedList.append(readed!)
                    }
                    
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
        myQuery()
        
        //下拉刷新
        let myRefresh = UIRefreshControl()
        myRefresh.tintColor = UIColor.red
        myRefresh.attributedTitle = NSAttributedString(string: "刷新中")
        myRefresh.addTarget(self, action: #selector(self.myQuery), for: .valueChanged)
        self.refreshControl = myRefresh
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
        return list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        
        cell.textLabel?.text = self.list[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        if readedList[indexPath.row] == false {
            cell.textLabel?.textColor = UIColor.red
        }else {
            cell.textLabel?.textColor = UIColor.black
        }
        
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let selectedTitle = self.list[indexPath.row]
        
        
        detailContent.replyTitle = selectedTitle
        
        let query = BmobQuery(className: "report")
        query?.whereKey("replytitle", equalTo: selectedTitle)
        query?.findObjectsInBackground({ (array, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            }else {
                for obj in array! {
                    let object = obj as! BmobObject
                    
                    object.setObject(true, forKey: "readed")
                    object.updateInBackground(resultBlock: { (success, error) in
                        if error != nil {
                            print("\(error?.localizedDescription)")
                            
                        }
                    })
                    
                }
                
            }
        })
        

        
        self.navigationController?.pushViewController(detailContent, animated: true)
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
