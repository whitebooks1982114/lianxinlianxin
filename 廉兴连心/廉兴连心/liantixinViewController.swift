//
//  liantixinViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/4.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit
import Charts

class liantixinViewController: UIViewController  {
    @IBOutlet weak var usrmenu: UIBarButtonItem!
    
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var newsView: UIView!
    
    
    @IBOutlet weak var noticeView: UIView!
    
    
    //加载图表
    @IBAction func loadChart(_ sender: UITapGestureRecognizer) {
        
        
        dataItem.xMax = 5.0
        dataItem.xInterval = 1.0
        dataItem.yMax = 10.0
        dataItem.yInterval = 1.0
        
        
        
        dataItem.axesColor = UIColor.blue
        dataItem.barPointArray = [CGPoint(x: 1.0, y: CGFloat(countOfNews)), CGPoint(x: 2.0, y: CGFloat(countOfNotice)), CGPoint(x: 3.0, y: CGFloat(countOfAlarm)),CGPoint(x: 4.0, y: CGFloat(countOfEmNotice)), CGPoint(x: 5.0, y: CGFloat(countOfEmAlarm))]
        dataItem.xAxesDegreeTexts = ["廉政要闻", "消息通知", "提醒事项","紧急通知","紧急事项"]
        
        dataItem.barColor = UIColor.orange
        let barChart: PDBarChart = PDBarChart(frame: CGRect(x: 0, y: 0, width: self.myView.frame.width - 20, height: self.myView.frame.height),dataItem: dataItem)
        
        self.myView.addSubview(barChart)
        barChart.strokeChart()
        
        
    }
    
    @IBOutlet weak var loadChartLabel: UILabel!
    
    @IBOutlet weak var alarmView: UIView!
    
    @IBOutlet weak var noticeImage: UIImageView!
 
    @IBOutlet weak var alarmImage: UIImageView!
    
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var newsLable: UILabel!
    
    
    @IBOutlet weak var noticeLabel: UILabel!
    
    
    @IBOutlet weak var alarmLabel: UILabel!
    
    let newsDir = dongtaiTableViewController()
    let noticeDir = tongziTableViewController()
    let alarmDir = tixinTableViewController()
    //图表Y轴计数
    var countOfNews = 0
    var countOfAlarm = 0
    var countOfNotice = 0
    var countOfEmNotice = 0
    var countOfEmAlarm = 0
    
    
    //柱状图
    let dataItem: PDBarChartDataItem = PDBarChartDataItem()
    @IBAction func toNewsDetail(_ sender: UITapGestureRecognizer) {
        
        self.navigationController?.pushViewController(newsDir, animated: true)
    }
    
    @IBAction func toNoticeDetail(_ sender: UITapGestureRecognizer) {
        
        self.navigationController?.pushViewController(noticeDir, animated: true)
    }
    
    
    @IBAction func toAlarmDetail(_ sender: UITapGestureRecognizer) {
        
        self.navigationController?.pushViewController(alarmDir, animated: true)
    }
    
   //查询数据库获取图表数据
    func chartData() {
        let queryNews = BmobQuery(className: "news")
        let queryAlarm = BmobQuery(className: "alarm")
        let queryNotice = BmobQuery(className: "notice")
        let noticeInQuery = BmobUser.query()
        let user = BmobUser.current()
        let userName = user?.username
        let userID = user?.objectId
        noticeInQuery?.whereKey("username", equalTo: userName)
        
        if user == nil {
            self.countOfNews = 0
            self.countOfAlarm = 0
            self.countOfNotice = 0
        }else {
            
            queryNews?.countObjectsInBackground({ (count, error) in
                if error != nil {
                    print("\(error?.localizedDescription)")
                }else {
                    self.countOfNews = Int(count)
                    
                }
            })
            let author = BmobUser(outDataWithClassName: "_User", objectId: userID)
            queryAlarm?.whereKey("author", equalTo: author)
            queryAlarm?.countObjectsInBackground({ (count, error) in
                if error != nil {
                    print("\(error?.localizedDescription)")
                }else {
                    self.countOfAlarm = Int(count)
                    
                }
            })
            queryNotice?.whereKey("relation", matchesQuery: noticeInQuery)
            queryNotice?.countObjectsInBackground({ (count, error) in
                if error != nil {
                    print("\(error?.localizedDescription)")
                }else {
                    self.countOfNotice = Int(count)
                    
                    
                }
            })
        }
        
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 310
            self.revealViewController().toggleAnimationDuration = 0.5
     
            
            self.usrmenu.target = self.revealViewController()
            
            self.usrmenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            self.newsImage.isHidden = true
            self.noticeImage.isHidden = true
            self.alarmImage.isHidden = true
            
            self.newsView.layer.masksToBounds = true
            self.newsView.layer.cornerRadius = 16
            
            self.noticeView.layer.masksToBounds = true
            self.noticeView.layer.cornerRadius = 16

            self.alarmView.layer.masksToBounds = true
            self.alarmView.layer.cornerRadius = 16
           
            
        }
        
        
                   // Do any additional setup after loading the view.
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let originNewsFrame = newsView.frame
        let originNoticeFrame = noticeView.frame
        let originAlarmFrame = alarmView.frame
        
        UIView.animate(withDuration: 2.0, animations: {
            self.newsView.alpha = 1
            self.newsView.frame.origin.y -= 400
        })
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .allowAnimatedContent, animations: {
            self.noticeView.alpha = 1
            self.noticeView.frame.origin.y -= 400
        }, completion: nil)
        
        UIView.animate(withDuration: 2.0, delay: 2.0, options: .allowAnimatedContent, animations: {
            self.alarmView.alpha = 1
            self.alarmView.frame.origin.y -= 400
            
        }, completion: nil)
        
        newsView.frame = originNewsFrame
        noticeView.frame = originNoticeFrame
        alarmView.frame = originAlarmFrame
        
        
        UIView.animate(withDuration: 2.0, delay: 2.0, options: [.repeat , .autoreverse], animations: {
                self.newsLable.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.noticeLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.alarmLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.newsLable.textColor = UIColor.cyan
            self.noticeLabel.textColor = UIColor.orange
            self.alarmLabel.textColor = UIColor.magenta
        }, completion: nil)
        myView.addSubview(loadChartLabel)
        
        chartData()
       
        
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let childsViews = self.myView.subviews
        for child in childsViews {
            child.removeFromSuperview()
        }
        
        self.myView.addSubview(loadChartLabel)
    }
    
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
