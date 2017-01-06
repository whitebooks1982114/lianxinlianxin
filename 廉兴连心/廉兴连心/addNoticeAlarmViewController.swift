//
//  addNoticeAlarmViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/19.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit


class addNoticeAlarmViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var myTabel: UITableView!
    @IBOutlet weak var sendMessage: UIButton!
    
    @IBOutlet weak var sendObject: UIView!
   @IBOutlet weak var noteicChecBox: UIView!
 
    @IBAction func noticeCheck(_ sender: UITapGestureRecognizer) {
        if noteicChecBox.backgroundColor == UIColor.white {
            noteicChecBox.backgroundColor = UIColor.blue
            noticeSelected = true
        }else{
            noteicChecBox.backgroundColor = UIColor.white
            noticeSelected = false
        }
        
        
    }
    @IBAction func alarmCheck(_ sender: UITapGestureRecognizer) {
        if alarmCheckBox.backgroundColor == UIColor.white {
            alarmCheckBox.backgroundColor = UIColor.blue
            alarmSelected = true
        }else{
            
            alarmCheckBox.backgroundColor = UIColor.white
            alarmSelected = false
            
        }
        
        
    }
    @IBOutlet weak var alarmCheckBox: UIView!
    //选择发送对象代码
    @IBAction func dropMenu(_ sender: UITapGestureRecognizer) {
        //如果网络不好没取到数组
        if self.trueNameList.count == 0 {
            let alert = UIAlertController(title: "错误信息", message: "无法连接服务器", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)

        }
        
       //按下按钮，将用户名和ID填入SELECETD表，建立指针关系
        
        for i in 0...self.trueNameList.count - 1 {
            
            self.indexPathToInsert.append(IndexPath(row: i, section: 0) as IndexPath)
            
             let post = BmobObject(className: "selected")
            post?.setObject(self.trueNameList[i], forKey: "chinesename")
            post?.setObject(false, forKey: "selected")
            let associateUser = BmobUser(outDataWithClassName: "_User", objectId: self.userId[i])
            post?.setObject(associateUser, forKey: "associateuser")
            post?.saveInBackground(resultBlock: { (success, error) in
                if error != nil {
//                    print("\(error?.localizedDescription)")
//                    let alert = UIAlertController(title: "错误信息", message: "发生错误", preferredStyle: .alert)
//                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
//                    alert.addAction(ok)
//                    self.present(alert, animated: true, completion: nil)
                    print("\(error?.localizedDescription)")
                    
                }
                
            })
            
        }
        
        //Tableview下拉动画
        
        let insertAnimation: UITableViewRowAnimation = .automatic
        
        myTabel.beginUpdates()
        if expend == true {
            self.myTabel.deleteRows(at: indexPathToInsert, with: insertAnimation)
            myTabel.isHidden = true
            expend = false
            
        }else {
            myTabel.isHidden = false
            self.myTabel.insertRows(at: indexPathToInsert, with: insertAnimation)
            expend = true
            
        }
        self.myTabel.endUpdates()
        
        
    }
    
    @IBOutlet weak var content: UITextView!
    
    @IBOutlet weak var deadline: UITextField!
    //点击TOOLBAR完成按钮，发送通知或提醒内容到数据库
    @IBAction func sendContent(_ sender: UIBarButtonItem) {
        if noticeSelected == true {
            saveNotice()
            
        }
      
        
        deadline.resignFirstResponder()
        
    }
    //发送按钮代码
    @IBAction func send(_ sender: UIButton) {
        
        if noticeSelected == true {
            
            sendNotice()
        }
        if alarmSelected == true {
            
            saveAlarm()
        }
        UIView.animate(withDuration: 1.0, animations:
            {
               self.sendMessage.titleLabel?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
        
       _ = self.navigationController?.popToRootViewController(animated: true)
    }
    //列表是否展开标志
    var expend:Bool = false
    //通知按钮被选中标志
    var noticeSelected:Bool = false
    //事项按钮被选中标志
    var alarmSelected:Bool = false
    //用户列表数组名字
    var trueNameList = [String]()
    //用户ID数组
    var userId = [String]()
   //返回通知数据ID
    var noticeID: String!
    //返回提醒数据ID
    var alarmID: String!
    //var bmobList: NSArray!
    //用户是否被选中数组
    var select = [Bool]()
    //用户名数组循环中当前的用户名
    var currentUserName:String!
    //用户名循环中当前的用户ID
    var currentUserId:String!
    
    var indexPathToInsert = [IndexPath]()
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
      
        myToolbar.removeFromSuperview()
        myDatePicker.removeFromSuperview()
    
       noteicChecBox.backgroundColor = UIColor.white
        alarmCheckBox.backgroundColor = UIColor.white
      
        
        myTabel.isHidden = true
        
        let usr = BmobUser.current()
        let isAdmin = usr?.object(forKey: "isadmin") as? Bool
        if isAdmin != true {
        
         self.noteicChecBox.isHidden = true
         //其他用户不能发通知，下拉列表视图按钮不可见
        self.sendObject.isHidden = true
        
        }
        
        
        
        deadline.delegate = self
        content.delegate = self
        
        myTabel.delegate = self
        myTabel.dataSource = self
        
        deadline.inputView = myDatePicker
        deadline.inputAccessoryView = myToolbar
        deadline.adjustsFontSizeToFitWidth = true
        self.navigationItem.title = "发送消息/通知"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.back))
        
        //查询用户，给他们都赋值为false
        let query1 = BmobQuery(className: "selected")
        query1?.findObjectsInBackground({ (array, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误信息", message: "\(error?.localizedDescription)", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                for obj in array! {
                    let user = obj as! BmobObject
                    user.setObject(false, forKey: "selected")
                    user.updateInBackground(resultBlock: { (success, error) in
                        if error != nil {
                            print("\(error?.localizedDescription)")
                        }
                    })
                    
                    
                }
                
            }
        })
        
        
        
        //查询用户，给他们都赋值为false,并将所有用户名和ID导入相应数组
         let query = BmobUser.query()
        query?.findObjectsInBackground({ (array, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误信息", message: "无法获得用户列表", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                for obj in array! {
               
                        let user = obj as! BmobUser
                         self.currentUserName = user.object(forKey: "chinesename") as! String
                         self.currentUserId = user.objectId as String
                   
                        self.trueNameList.append(self.currentUserName)
                        self.userId.append(self.currentUserId)
                        self.select.append(false)
                    
                    

                }
            }
                
        })
       
        
    }
    
    func back() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.content.resignFirstResponder()
        self.deadline.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.deadline.resignFirstResponder()
        return true
    }
    
    func change(_ dater: UIDatePicker) {
        let date = dater.date
        let dateformatter:DateFormatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        self.deadline.text = dateformatter.string(from: date)
        let string = dateformatter.string(from: date)
        self.deadline.text = string
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.myDatePicker.addTarget(self, action: #selector(self.change(_:)), for: .valueChanged)
        noteicChecBox.backgroundColor = UIColor.white
        alarmCheckBox.backgroundColor = UIColor.white
   
    }
  
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if expend == false{
            return 0
        }else {
        
        
        return trueNameList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        
        cell.textLabel?.text = trueNameList[indexPath.row]
        if select[indexPath.row] {
            
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        
        cell.backgroundColor = UIColor.lightGray
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectName = trueNameList[indexPath.row]
        let query = BmobQuery(className: "selected")
        query?.whereKey("chinesename", equalTo: selectName)
        query?.findObjectsInBackground({ (array, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            }else {
                for obj in array! {
                    let user = obj as! BmobObject
                    
                    var isSelected = user.object(forKey: "selected") as! Bool
                    
                    if isSelected {
                       
                        isSelected = false
                        user.setObject(isSelected, forKey: "selected")
                        user.updateInBackground(resultBlock: { (success, error) in
                            if error != nil {
                                print("\(error?.localizedDescription)")
                                
                            }
                        })
                        self.select[indexPath.row] = false
                         tableView.deselectRow(at: indexPath, animated: true)
                        tableView.reloadData()
                        
                    }else {
                        
                        isSelected = true
                        user.setObject(isSelected, forKey: "selected")
                        user.updateInBackground(resultBlock: { (success, error) in
                            if error != nil {
                                print("\(error?.localizedDescription)")
                            }
                        })
                        self.select[indexPath.row] = true
                        tableView.deselectRow(at: indexPath, animated: true)
                        tableView.reloadData()
                        
                    }
                    
                }
                
            }
        })
        
        
    }
    //IPhone 5s屏幕输入时调整动画
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let frame: CGRect = deadline.frame
        
        let offset = frame.origin.y + 100 - (self.view.frame.size.height - 240)
        
        if offset > 0 {
            UIView.animate(withDuration: 0.8, animations: {
                self.view.frame = CGRect(x: 0, y: -offset, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
      //IPhone 5s屏幕输入时调整动画
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.8, animations: {
             self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        })
       
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //查询用户，给他们都赋值为false
        let query = BmobQuery(className: "selected")
        query?.findObjectsInBackground({ (array, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误信息", message: "\(error?.localizedDescription)", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                for obj in array! {
                    let user = obj as! BmobObject
                 user.setObject(false, forKey: "selected")
                    user.updateInBackground(resultBlock: { (success, error) in
                        if error != nil {
                            print("\(error?.localizedDescription)")
                        }
                    })
                    
                    
                }
                
            }
        })
        
    }
    //传送通知内容等信息至BMOB数据库
    func saveNotice() {
        let dateString = self.deadline.text
        let dateformatter:DateFormatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let noticeDate = dateformatter.date(from: dateString!)
        let noticeContent = self.content.text
        let post = BmobObject(className: "notice")
        post?.setObject(noticeDate, forKey: "deadline")
        post?.setObject(noticeContent, forKey: "content")
        post?.setObject("通知" + (dateString)!, forKey: "title")
        post?.saveInBackground(resultBlock: { (sucess, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误信息", message: "\(error?.localizedDescription)", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "返回主界面", style: .destructive, handler: { (act) in
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }else {
                if let newNotice = post {
                    
                    self.noticeID = newNotice.objectId
                    
                }
                
                
            }
        })
       
    }
    //传送提醒内容等信息至BMOB数据库
    func saveAlarm() {
        
        
        let dateString = self.deadline.text
        let dateformatter:DateFormatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let noticeDate = dateformatter.date(from: dateString!)
        let noticeContent = self.content.text
        let user = BmobUser.current()
        let userID = user?.objectId
        let post = BmobObject(className: "alarm")
        post?.setObject(noticeDate, forKey: "deadLine")
        post?.setObject(noticeContent, forKey: "alarmContent")
        post?.setObject("提醒" + (dateString)!, forKey: "alarmTitle")
        let author = BmobUser(outDataWithClassName: "_User", objectId: userID)
        post?.setObject(author, forKey: "author")
        post?.saveInBackground(resultBlock: { (sucess, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误信息", message: "\(error?.localizedDescription)", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "返回主界面", style: .destructive, handler: { (act) in
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }  else {
                if let newAlarm = post {
                    
                    self.alarmID = newAlarm.objectId
                    
                }
                
            }
        })
  
    }
    
    
    //发送通知方法
    func sendNotice() {
        
        
       let sendNotcie = BmobObject(outDataWithClassName: "notice", objectId: self.noticeID)
  
        let relation = BmobRelation()
        
        for i in 0...self.select.count - 1 {
            if self.select[i] == true {
                relation.add(BmobObject(outDataWithClassName: "_User", objectId: self.userId[i]))
           
            }

        }
       sendNotcie?.add(relation, forKey: "relation")
       sendNotcie?.updateInBackground(resultBlock: { (success, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
               
            }
        })
        

        
    }
    
      
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
