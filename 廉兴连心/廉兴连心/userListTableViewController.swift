//
//  userListTableViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/4.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class userListTableViewController: UITableViewController {
    //aboutUs实例化
    let aboutUs = aboutUsViewController()
    
    let userInfoChange = userInfoChangeViewController()
    
    let contribuionInfo = contributionInfoViewController()
    @IBOutlet weak var avatar: UIImageView?
   
    @IBOutlet weak var username: UILabel?
    
    @IBOutlet weak var chinesename: UILabel?
    @IBAction func usrInfo(_ sender: UIButton) {
        self.present(userInfoChange, animated: true, completion: nil)
        
    }
    
    @IBAction func compInfo(_ sender: UIButton) {
        self.present(contribuionInfo, animated: true, completion: nil)
    }
    
    
    @IBAction func logOut(_ sender: UIButton) {
        BmobUser.logout()
   
    }
    
    
    @IBAction func aboutUs(_ sender: UIButton) {
        self.present(aboutUs, animated: true, completion: nil)
        
        
    }
    
    
    @IBOutlet weak var usrInfoOut: UIButton?
    
    @IBOutlet weak var compInfoOut: UIButton?
    
    @IBOutlet weak var logOutOut: UIButton?
  
    
    @IBOutlet weak var aboutUsOut: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //按钮标题左对齐
        self.usrInfoOut?.contentHorizontalAlignment = .left
        self.compInfoOut?.contentHorizontalAlignment = .left
        self.logOutOut?.contentHorizontalAlignment = .left
        self.aboutUsOut?.contentHorizontalAlignment = .left
        self.tableView.tableFooterView = UIView()
        self.tableView.tableFooterView?.backgroundColor = UIColor.black
        //使表头不与状态栏重叠
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        //设置分割线顶头
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //设置圆角
        self.avatar?.layer.masksToBounds = true
        self.avatar?.layer.cornerRadius = 8
        
             
               // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let nowuser = BmobUser.current()
        //加载用户名
        let currentUser = nowuser?.object(forKey: "username")
        if currentUser != nil {
            self.username?.text = currentUser as? String
        }else {
            self.username?.text = "用户名"
        }
       //加载中文名
        let currentChineseName = nowuser?.object(forKey: "chinesename")
        if currentChineseName != nil {
            self.chinesename?.text = currentChineseName as? String
        }else {
            self.chinesename?.text = "姓名"
        }
      
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = "\(rootPath)/pickedimage.jpg"
        
        if FileManager.default.fileExists(atPath: path) == false {
            self.avatar?.image = UIImage(named: "头像")
        }
        
        if nowuser != nil {
        
       
        
        self.avatar?.image = UIImage(contentsOfFile: path)
        
      
        } else {
            self.avatar?.image = UIImage(named: "头像")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       if section == 0 {
            return 1
        } else {
        
        return 4
        }
      
    }
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)

        // Configure the cell...

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            return cell
        }
        
    } */
    

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
