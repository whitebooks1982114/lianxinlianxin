//
//  DongTaiViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 17/1/26.
//  Copyright © 2017年 whitebooks. All rights reserved.
//

import UIKit
import Kingfisher



class DongTaiViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    //判断用户是否关闭提醒音效
    var noticeVoiceOn: Bool = true
    //网络加载指示器，如果新闻首页加载慢，会出现转动画面，加载完毕停止转动
   let myActivi = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    @IBOutlet weak var usrmenu: UIBarButtonItem!
    
    var alarmVoiceOn: Bool = true
    //通知，事项提醒提前天数设置
    var alarmDaysSetting = 0.0
    
    //通知、事项开关点击次数
    var noticeSwitchTimes:Int?
    
    var alarmSwitchTimes:Int?
    //用户积分
    var totalScore : Int?
    
    
    //用户ID
    var currentUserId = ""
    //到期通知到期日数组
    var deadlineNotices = [Date]()
    //到期提醒到期日数组
    var deadlineAlarms = [Date]()
    
   
    

    
    var label:UILabel!
    var newsView:UITableView!
    var btn1:UIButton!
    var btn2:UIButton!
    var btn3:UIButton!
    var adSCView:UIScrollView!
    var pageControl:UIPageControl?
    
    let textNewsDetail = TextNewsDetailViewController()
    let imageNewsDetail = imageNewsViewController()
    let vedioNewsDetail = VedioNewsViewController()
    //滚动视图定时器
    var timer:Timer?
    
    var headLineNews:String!
    var timeAdjust:Double!
    
    var newsKind:String!
   
    //切换顶部频道后查询新闻数据
    
    var newsImageUrl:URL?
    var newsVedioUrl:URL?
    
    var newsTitle = [String]()
    var newsContents = [String]()
    var cellKind = [String]()
    var newsImage = [URL]()
    var newsVedio = [URL]()
    func queryNews(){
        newsTitle.removeAll()
       newsContents.removeAll()
        cellKind.removeAll()
        newsImage.removeAll()
        newsVedio.removeAll()
        self.myActivi.startAnimating()
        
        let query = BmobQuery(className: "news")
        query?.order(byDescending: "updatedAt")
        query?.whereKey("level", equalTo: newsKind)
        query?.findObjectsInBackground({ (array, error) in
            if error != nil {
                self.newsTitle.append("数据更新失败")
                
            }else {
                for obj in array! {
                    let detailObject = obj as! BmobObject
                    let cellTitle = detailObject.object(forKey: "title") as! String
                    
                   // 查询并判断图片文件
                    let cellImageFile = detailObject.object(forKey: "image") as? BmobFile
                    if cellImageFile != nil {
                    self.newsImageUrl = NSURL(string: (cellImageFile?.url)!) as URL?
                    }else {
                     self.newsImageUrl = NSURL(string: "") as? URL
                    }
                    //查询并判断视频文件
                    let cellVedioFile = detailObject.object(forKey: "vedio") as? BmobFile
                    if cellVedioFile != nil {
                        self.newsVedioUrl = NSURL(string: (cellVedioFile?.url)!) as URL?
                    }else {
                        self.newsVedioUrl = NSURL(string: "") as? URL
                    }
                    let cellKindStr = detailObject.object(forKey: "cellkind") as! String
                    let newsContent = detailObject.object(forKey: "content") as! String
                    
                    self.newsTitle.append(cellTitle)
                    self.newsImage.append(self.newsImageUrl!)
                    self.newsVedio.append(self.newsVedioUrl!)
                    self.cellKind.append(cellKindStr)
                    self.newsContents.append(newsContent)
                    
                    
                }
               
                
            }
            
            DispatchQueue.main.async {
                self.newsView.reloadData()
                //TABLEView 加载完毕后强制重新布局，使ACTIVITYINDICATOR停止转动
                self.newsView.layoutIfNeeded()
                self.myActivi.stopAnimating()
                
            }
            
        })
        

    }
    //加载头条新闻
    func queryHeadLine(){
        let query = BmobQuery(className: "headlinenews")
        query?.getObjectInBackground(withId: "CyM35558", block: { (obj, error) in
            if error != nil {
                self.headLineNews = "无头条新闻"
            }else{
                self.headLineNews = obj?.object(forKey: "headline") as! String!
            }
            
            DispatchQueue.main.async {
                self.label = UILabel(frame: CGRect(x: 100.0, y: 70.0, width: 200.0, height: 20.0))
                
                self.label?.textColor = UIColor.red
                self.label?.backgroundColor = UIColor.clear
                
                self.label?.numberOfLines = 1
                self.label?.textAlignment = .center
                
                self.label?.font = UIFont.systemFont(ofSize: 17)

                self.label.text = self.headLineNews
                let text:String = (self.label?.text!)!
                let attributes = [NSFontAttributeName: self.label?.font!]//计算label的字体
                self.label?.frame = self.labelSize(text: text, attributes: attributes as [NSObject : AnyObject])//调用计算label宽高的方法
                self.label?.frame.origin.x = UIScreen.main.bounds.width
                self.label?.frame.origin.y = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)! + 30
                
                self.view.addSubview(self.label!)
                
                self.timeAdjust = Double(self.label.frame.width)
                UIView.animate(withDuration: 0.1 * Double(self.timeAdjust), delay: 0, options: [.repeat,.curveLinear], animations: {
                    self.label?.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width - (self.label?.frame.size.width)!, y: 0)
                }, completion: nil)
              
            }
        })
    }

    var imageList = [UIImageView]()
    var dataList = [NSURL]()
    //加载新闻头条图片
    func queryHeadImage(){
        self.dataList.removeAll()
        
        for subview in adSCView!.subviews {
            
            subview.removeFromSuperview()
            
        }
        //重要：每次加载都把pageContol从父视图删除，否则圆点总数会叠加显示
        if self.pageControl != nil{
        self.pageControl?.removeFromSuperview()
        }
        
        let query = BmobQuery(className: "headlinenews")
        query?.whereKey("kind", equalTo: newsKind)
        query?.findObjectsInBackground({ (array, error) in
            if error != nil {
                let myImageView = UIImageView(image: UIImage(named: "默认图片"))
                self.adSCView.addSubview(myImageView)
            }else if array == nil {
                let defaultImageView = UIImageView(image: UIImage(named: "默认图片"))
                defaultImageView.frame = (CGRect(x: 0, y: 0, width: self.view.frame.width, height:250))
             
          
                self.adSCView.addSubview(defaultImageView)
                
            }
            else{
                for obj in array! {
                    let imageObj = obj as! BmobObject
                    let newsImageFile = imageObj.object(forKey: "image") as? BmobFile
                    let url = NSURL(string: (newsImageFile?.url)!)
             
                    self.dataList.append(url!)
                }
            }
            
            DispatchQueue.main.async {
              
                let count = self.dataList.count
                self.adSCView = UIScrollView()
                self.adSCView.delegate = self
                self.adSCView.isPagingEnabled = true
                self.adSCView.frame = CGRect(x: 0, y: 50 + UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!, width: self.view.frame.width, height:250)
                self.adSCView.contentSize = CGSize(width: CGFloat(self.dataList.count) * self.adSCView.frame.width,height: self.adSCView.frame.height)
                self.adSCView.contentInset = UIEdgeInsetsMake(0, self.view.frame.width, 0, self.view.frame.width)
                self.newsView.tableHeaderView = self.adSCView
              

                
                if count == 0 {
                     let myImageView = UIImageView(image: UIImage(named: "默认图片"))
                    self.adSCView.addSubview(myImageView)
                }else {
                    for index in 0..<count {
                        let newsImageView = UIImageView(frame: CGRect(x: CGFloat(index) * self.view.frame.width, y: 0, width: self.view.frame.width, height:250))
                        newsImageView.contentMode = .scaleToFill
                     
                    newsImageView.kf.setImage(with: ImageResource.init(downloadURL: self.dataList[index] as URL), placeholder: UIImage(named:"默认图片"), options: nil, progressBlock: nil, completionHandler: nil)
                        self.adSCView.addSubview(newsImageView)
                    }
                    let leftImageView = UIImageView(frame: CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width, height:250))
              
                    leftImageView.kf.setImage(with: ImageResource.init(downloadURL: self.dataList[count - 1] as URL), placeholder: UIImage(named:"默认图片"), options: nil, progressBlock: nil, completionHandler: nil)
                    self.adSCView.addSubview(leftImageView)
                    
                    let rightImageView = UIImageView(frame: CGRect(x: CGFloat(count) * self.view.frame.size.width, y: 0, width: self.view.frame.width, height:250))
              
                    rightImageView.kf.setImage(with: ImageResource.init(downloadURL: self.dataList[0] as URL), placeholder: UIImage(named:"默认图片"), options: nil, progressBlock: nil, completionHandler: nil)
                    
                    self.adSCView.addSubview(rightImageView)
                    
                    if ((self.timer?.isValid) != nil) {
                        
                        self.timer?.invalidate()
                        
                    }
                    
                    self.pageControl = UIPageControl(frame: CGRect(x: UIScreen.main.bounds.width / 4.0, y: 50 + UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)! + 210, width: 150, height: 30))
         
                    self.pageControl?.numberOfPages = count
                    self.pageControl?.currentPageIndicatorTintColor = UIColor.red
                    self.view.addSubview(self.pageControl!)
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.timerHanle), userInfo: nil, repeats: true)
                    
                }
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 310
            self.revealViewController().toggleAnimationDuration = 0.5
            
            
            self.usrmenu.target = self.revealViewController()
            
            self.usrmenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
                     
        }

        
        self.navigationItem.title = "新闻首页"
       queryHeadLine()
        newsKind = "中央"
        
        
        newsView = UITableView(frame: CGRect(x: 0, y:50 + UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!, width: self.view.frame.width, height: self.view.frame.height - 80 - UIApplication.shared.statusBarFrame.height - (self.navigationController?.navigationBar.frame.height)!))
        
        self.adSCView = UIScrollView()
        self.adSCView.delegate = self
        self.adSCView.isPagingEnabled = true
        self.adSCView.frame = CGRect(x: 0, y: 50 + UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!, width: self.view.frame.width, height:250)
     
       
        
        self.newsView.delegate = self
        self.newsView.dataSource = self
      
        
        let nibImage = UINib(nibName: "ImageTableViewCell", bundle: Bundle.main)
        let nibVedio = UINib(nibName: "VedioTableViewCell", bundle: Bundle.main)
        let nibText = UINib(nibName: "TextTableViewCell", bundle: Bundle.main)
        self.newsView.register(nibImage, forCellReuseIdentifier: "imagecell")
        self.newsView.register(nibVedio, forCellReuseIdentifier: "vediocell")
        self.newsView.register(nibText, forCellReuseIdentifier: "textcell")

    
      self.newsView.separatorStyle = .none
   
        
      btn1 = UIButton(frame: CGRect(x: 0.0, y: UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!, width: UIScreen.main.bounds.width / 3.0, height: 30))
      btn1.setTitle("中央精神", for: .normal)
      btn1.setTitleColor(UIColor.black, for: .normal)
      btn1.backgroundColor = UIColor.clear
      btn1.setTitleColor(UIColor.red, for: .selected)
        btn1.isSelected = true
       btn1.tag = 1
        btn2 = UIButton(frame: CGRect(x: UIScreen.main.bounds.width / 3.0, y: UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!, width: UIScreen.main.bounds.width / 3.0, height: 30))
        btn2.setTitle("上级动态", for: .normal)
        btn2.setTitleColor(UIColor.black, for: UIControlState())
        btn2.backgroundColor = UIColor.clear
        btn2.setTitleColor(UIColor.red, for: .selected)
        btn2.tag = 2
         btn3 = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 2.0 / 3.0, y: UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!, width: UIScreen.main.bounds.width / 3.0, height: 30))
        btn3.setTitle("基层声音", for: .normal)
        btn3.setTitleColor(UIColor.black, for: UIControlState())
        btn3.backgroundColor = UIColor.clear
        btn3.setTitleColor(UIColor.red, for: .selected)
        btn3.tag = 3
        btn1.addTarget(self, action: #selector(zyView(btn:)), for: .touchUpInside)
         btn2.addTarget(self, action: #selector(sjView(btn:)), for: .touchUpInside)
         btn3.addTarget(self, action: #selector(jcView(btn:)), for: .touchUpInside)
        
       
        
        self.view.addSubview(btn1)
         self.view.addSubview(btn2)
         self.view.addSubview(btn3)
        self.view.addSubview(newsView)
        
        
        myActivi.frame.origin.x = UIScreen.main.bounds.width / 2
        myActivi.frame.origin.y = UIScreen.main.bounds.height / 2
        self.view.addSubview(myActivi)
        myActivi.startAnimating()
        myActivi.color = UIColor.red
        
        
     
     
    }
    func labelSize(text:String ,attributes : [NSObject : AnyObject]) -> CGRect{
        var size = CGRect();
        let size2 = CGSize(width: 0, height: 20);//设置label的最大宽度
        size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as? [String : AnyObject] , context: nil);
        return size
    }

    
    func zyView(btn:UIButton) {
        btn.isSelected = true
        self.btn2.isSelected = false
        self.btn3.isSelected = false
        self.newsKind = "中央"
        queryHeadImage()
        queryNews()
    }
    func sjView(btn:UIButton) {
         btn.isSelected = true
        self.btn1.isSelected = false
        self.btn3.isSelected = false
        self.newsKind = "上级"
       queryHeadImage()
        queryNews()
    }
    func jcView(btn:UIButton) {
         btn.isSelected = true
        self.btn1.isSelected = false
        self.btn2.isSelected = false
        self.newsKind = "基层"
       queryHeadImage()
        queryNews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        queryHeadLine()
        queryHeadImage()
        queryNews()
        
        //查询答题闯关界面各个试卷的objectid
        
        objectIDs.removeAll()
        
        let query1 = BmobQuery(className: "tests")
        query1?.order(byAscending: "testid")
        query1?.findObjectsInBackground({ (array, error) in
            if error != nil {
               print("\(error?.localizedDescription)")
            }else if array != nil{
                for obj in array! {
                    let object = obj as! BmobObject
                    let ids = object.object(forKey: "testid") as! Int
                    objectIDs.append(ids)
                    
                }
            }else {
                print("题目为空")
            }
        })

        
       
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        
        noticeVoiceOn = UserDefaults.standard.bool(forKey: "noticevoice")
        
        
        alarmVoiceOn = UserDefaults.standard.bool(forKey: "alarmvoice")
        
        noticeSwitchTimes = UserDefaults.standard.integer(forKey: "noticetimes")
        
        alarmSwitchTimes = UserDefaults.standard.integer(forKey: "alarmtimes")
        //默认通知、提醒事项开关开启
        if noticeSwitchTimes == 0 {
            noticeVoiceOn = true
            UserDefaults.standard.set(true, forKey: "noticevoice")
        }
        
        if alarmSwitchTimes == 0 {
            alarmVoiceOn = true
            UserDefaults.standard.set(true, forKey: "alarmvoice")
        }
        
        alarmDaysSetting = Double(UserDefaults.standard.float(forKey: "days"))
        
        //默认提前1天提醒
        if alarmDaysSetting == 0.0 {
            alarmDaysSetting = 1.0
        }
        
        let currentDay = Date()
        
        let nextDay = currentDay.addingTimeInterval((alarmDaysSetting * 24.0 + 8.0) * 60.0 * 60.0)
        
        
        let chinaDay = currentDay
        let user = BmobUser.current()
        let userQuery = BmobUser.query()
        if user != nil {
            //查询马上到期的通知，并发出本地通知
            
            let query = BmobQuery(className: "notice")
            let noticeInQuery = BmobUser.query()
            let userName = user?.username
            
            noticeInQuery?.whereKey("username", equalTo: userName)
            query?.whereKey("relation", matchesQuery: noticeInQuery)
            let query1 = BmobQuery(className: "notice")
            query1?.whereKey("deadline", lessThan: nextDay)
            let quer2 = BmobQuery(className: "notice")
            quer2?.whereKey("deadline", greaterThan: chinaDay)
            let main = BmobQuery(className: "notice")
            main?.add(quer2)
            main?.add(query1)
            main?.add(query)
            main?.andOperation()
            main?.findObjectsInBackground({ (array, error) in
                if array != nil {
                    for obj in array! {
                        let object = obj as! BmobObject
                        let deadline = object.object(forKey: "deadline") as! Date
                        
                        self.deadlineNotices.append(deadline)
                      noticeArrayIsNotNull = true
                    }
                }
                DispatchQueue.main.async {
                 
                    if self.noticeVoiceOn == true {
                        for i in 0..<self.deadlineNotices.count{
                            let content = UNMutableNotificationContent()
                            content.title = "到期通知提醒，第\(i + 1)个通知提醒"
                            
                           content.subtitle = "到期日期\(self.deadlineNotices[i])"
                            content.body = "请及时查看相关通知内容 "
                            content.sound = UNNotificationSound.default()
                         
                        
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60 * 12, repeats: true)
                            let request = UNNotificationRequest(identifier: "notification.notice.\(i)", content: content, trigger: trigger)
                            
                            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                            
                        }
                        
                    }
                    if self.noticeVoiceOn == false {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                        
                    }
                }
                if error != nil {
                    print("\(error?.localizedDescription)")
                }
                
            })
            
            
            //查询马上到期提醒事项，并发出音效
            
            let queryAlarm = BmobQuery(className: "alarm")
            let id = user?.objectId
            let author = BmobUser(outDataWithClassName: "_User", objectId: id)
            queryAlarm?.whereKey("author", equalTo: author)
            let queryAlarm1 = BmobQuery(className: "alarm")
            queryAlarm1?.whereKey("deadLine", lessThan: nextDay)
            let querAlarm2 = BmobQuery(className: "alarm")
            querAlarm2?.whereKey("deadLine", greaterThan: chinaDay)
            let mainAlarm = BmobQuery(className: "alarm")
            mainAlarm?.add(queryAlarm)
            mainAlarm?.add(queryAlarm1)
            mainAlarm?.add(querAlarm2)
            mainAlarm?.andOperation()
            mainAlarm?.findObjectsInBackground({ (array, error) in
                if array != nil {
                    
                    for obj in array! {
                        
                        let object = obj as! BmobObject
                        let deadline = object.object(forKey: "deadLine") as! Date
                        self.deadlineAlarms.append(deadline)
                        alarmArrayIsNotNull = true
                    }
                    
                }
                
                DispatchQueue.main.async {
                    
                    if self.alarmVoiceOn == true {
                        for i in 0..<self.deadlineAlarms.count{
                            let content = UNMutableNotificationContent()
                            content.title = "到期提醒事项，第\(i + 1)个事项提醒"
                            
                            content.subtitle = "到期日期\(self.deadlineAlarms[i])"
                            content.body = "请及时查看相关事项内容"
                            content.sound = UNNotificationSound.default()
                            
                          
                            
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60 * 12, repeats: true)
                            let request = UNNotificationRequest(identifier: "notification.alarm.\(i)", content: content, trigger: trigger)
                            
                            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                            
                        }
                        
                    }
                    if self.alarmVoiceOn == false {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                         UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    }
                }

                if error != nil {
                    print("\(error?.localizedDescription)")
                }
                
                
            })
            
            //将用户指针信息添加到USERSCORE表中
            let post = BmobObject(className: "userscore")
            userQuery?.findObjectsInBackground({ (array, error) in
                if error != nil {
                    print("\(error?.localizedDescription)")
                    let alert = UIAlertController(title: "错误信息", message: "无法获得用户列表", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    for obj in array! {
                        
                        let user = obj as! BmobUser
                        
                        self.currentUserId = user.objectId as String
                        
                        let author = BmobUser(outDataWithClassName: "_User", objectId: self.currentUserId)
                        post?.setObject(author, forKey: "author")
                        post?.saveInBackground(resultBlock: { (finish, error) in
                            if error != nil {
                                print("\(error?.localizedDescription)")
                            }
                        })
                        
                    }
                }
            })
            
            
        }

       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let imageCell = tableView.dequeueReusableCell(withIdentifier: "imagecell", for: indexPath) as! ImageTableViewCell
        
       
        let vedioCell = tableView.dequeueReusableCell(withIdentifier: "vediocell", for: indexPath) as! VedioTableViewCell
        let textCell = tableView.dequeueReusableCell(withIdentifier: "textcell", for: indexPath) as! TextTableViewCell
        
        if self.cellKind.count == 0 {
            return textCell
        }else {
       
        
        if self.cellKind[indexPath.row] == "t" {
            textCell.textLabel?.text = self.newsTitle[indexPath.row]
            textCell.textLabel?.numberOfLines = 0
            textCell.textLabel?.preferredMaxLayoutWidth = tableView.bounds.width
            return textCell
            
        }else if self.cellKind[indexPath.row] == "i"{
            imageCell.myImageLabel.text = self.newsTitle[indexPath.row]
            imageCell.myImageLabel.numberOfLines = 0
            imageCell.myImageLabel.lineBreakMode = .byWordWrapping
            imageCell.myImageLabel.adjustsFontSizeToFitWidth = true
            imageCell.myImageView?.kf.setImage(with: ImageResource.init(downloadURL: self.newsImage[indexPath.row]),placeholder: UIImage(named:"默认图片"), options: nil, progressBlock: nil, completionHandler: nil)
            
            //重要：使CELL点击后图片不会突然变大
            imageCell.selectionStyle = .none
           
            return imageCell
            
        }else {
            vedioCell.vedioTitle.text = self.newsTitle[indexPath.row]
            vedioCell.vedioTitle.numberOfLines = 0
            vedioCell.vedioTitle.lineBreakMode = .byWordWrapping
            vedioCell.selectionStyle = .none
            return vedioCell
        }
        
    }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.cellKind.count == 0 {
            return 30.0
        }else {
        
        if self.cellKind[indexPath.row] == "t" {
            
            let textCell = tableView.dequeueReusableCell(withIdentifier: "textcell", for: indexPath) as! TextTableViewCell
          
            return textCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 1
            
        }else if self.cellKind[indexPath.row] == "i"{
           let imageCell = tableView.dequeueReusableCell(withIdentifier: "imagecell", for: indexPath) as! ImageTableViewCell
            
            return imageCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 1
            
        }else {
             let vedioCell = tableView.dequeueReusableCell(withIdentifier: "vediocell", for: indexPath) as! VedioTableViewCell
            return vedioCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 1
        }
    }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableViewAutomaticDimension
     

    }
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedKind = self.cellKind[indexPath.row]
        
        switch selectedKind {
        case "t":
            textNewsDetail.newsTitle = self.newsTitle[indexPath.row]
            textNewsDetail.newsContent = self.newsContents[indexPath.row]
        
            self.navigationController?.pushViewController(textNewsDetail , animated: true)
        case "i":
            imageNewsDetail.newsTitle = self.newsTitle[indexPath.row]
            imageNewsDetail.newsContent = self.newsContents[indexPath.row]
            imageNewsDetail.newsImageUrl = self.newsImage[indexPath.row]
            self.navigationController?.pushViewController(imageNewsDetail, animated: true)
        default:
            vedioNewsDetail.myTitle = self.newsTitle[indexPath.row]
            vedioNewsDetail.myURL = self.newsVedio[indexPath.row] 
            self.navigationController?.pushViewController(vedioNewsDetail, animated: true)
        }
        
        
    }
   
   
    

    func timerHanle(){
        if self.dataList.count == 0 {
            self.adSCView.isScrollEnabled = false
        }else{
        
        self.adSCView?.setContentOffset(CGPoint(x: self.adSCView!.contentOffset.x + self.view.frame.size.width, y: 0), animated: true)
        self.pageControl?.currentPage = Int(self.adSCView.contentOffset.x / self.view.frame.width) + 1
        }
        
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        
        if point.x == -self.view.frame.size.width {
            
            scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - self.view.frame.size.width, y: 0), animated: false)
            self.pageControl?.currentPage = self.dataList.count
            
        }else if point.x == scrollView.contentSize.width {
            
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self.pageControl?.currentPage = 0
            
        }
        
        //当向下拉动时影藏pagecontrol
        
        if  scrollView == self.newsView {
            let y = scrollView.contentOffset.y
            if y != 0 {
                self.pageControl?.isHidden = true
            }else {
                self.pageControl?.isHidden = false
            }
            
        }

    }
    
    //MARK: 实现手动滚动视图，之后重新执行定时器
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer?.invalidate()

        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
         self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.timerHanle), userInfo: nil, repeats: true)
     
    }
    //手动拖拽图片，更新pageControl的指示标志
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.x > 0.0 {
          
            self.pageControl?.currentPage += 1
        }else{
        
            self.pageControl?.currentPage -= 1
        }
        
    
    }

   

}
