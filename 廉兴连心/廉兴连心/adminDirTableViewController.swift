//
//  adminDirTableViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/2.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class adminDirTableViewController: UITableViewController {
   
    
    var list = [String]()
    var deadLine = [NSDate]()
    var alarmContent = [String]()
    //提醒事项的id
    var objectID = [String]()
    //监察人员设置提前天数
    var adminSettingDays = 0.0

    let adminDetail = adminDetailViewController()
    
    func alarmQuery() {
        
        list.removeAll()
        let currentDay = Date()
        
        adminSettingDays = Double(UserDefaults.standard.integer(forKey: "adminSettingDays"))
        let nextDay = currentDay.addingTimeInterval(adminSettingDays * 24.0 * 60.0 * 60.0)
        
        
        let chinaDay = currentDay
       
            
            //查询马上到期(提前一天)提醒事项，并发出音效
        
            let queryAlarm1 = BmobQuery(className: "alarm")
            queryAlarm1?.whereKey("deadLine", lessThan: nextDay)
            let querAlarm2 = BmobQuery(className: "alarm")
            querAlarm2?.whereKey("deadLine", greaterThan: chinaDay)
            let mainAlarm = BmobQuery(className: "alarm")
        
            mainAlarm?.add(queryAlarm1)
            mainAlarm?.add(querAlarm2)
            mainAlarm?.andOperation()
            mainAlarm?.findObjectsInBackground({ (array, error) in
                if array != nil {
                    
                    for obj in array! {
                        
                        let object = obj as! BmobObject
                        let date = object.object(forKey: "deadLine") as! NSDate
                        let title = object.object(forKey: "alarmTitle") as! String
                        let content = object.object(forKey: "alarmContent") as! String
                        let id = object.objectId
                   
                        self.list.append(title)
                        self.alarmContent.append(content)
                        self.deadLine.append(date)
                        self.objectID.append(id!)
                    }
                  
                }
                
                if error != nil {
                    print("\(error?.localizedDescription)")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            })
            
            
          self.refreshControl?.endRefreshing()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "到期提醒事项目录"
     
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "通知背景"))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
     
    
        let myRefresh = UIRefreshControl()
        myRefresh.tintColor = UIColor.red
        myRefresh.attributedTitle = NSAttributedString(string: "刷新中")
        myRefresh.addTarget(self, action: #selector(self.alarmQuery), for: .valueChanged)
        self.refreshControl = myRefresh

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        alarmQuery()
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
       

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTitle  = list[indexPath.row]
        let selectedDate = self.deadLine[indexPath.row]
        let selectedContent = self.alarmContent[indexPath.row]
        let selectedId = objectID[indexPath.row]
        
      
        
        self.adminDetail.adminDate = selectedDate
        self.adminDetail.adminTitle = selectedTitle
        self.adminDetail.adminContent = selectedContent
        self.adminDetail.id  = selectedId
        
        self.navigationController?.pushViewController(adminDetail, animated: true)
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
