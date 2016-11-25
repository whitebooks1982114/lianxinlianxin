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
    
    
    @IBAction func toNewsDetail(_ sender: UITapGestureRecognizer) {
        
        self.navigationController?.pushViewController(newsDir, animated: true)
    }
    
    @IBAction func toNoticeDetail(_ sender: UITapGestureRecognizer) {
        
        self.navigationController?.pushViewController(noticeDir, animated: true)
    }
    
    
    @IBAction func toAlarmDetail(_ sender: UITapGestureRecognizer) {
        
        self.navigationController?.pushViewController(alarmDir, animated: true)
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
        //柱状图
        let dataItem: PDBarChartDataItem = PDBarChartDataItem()
        dataItem.xMax = 5.0
        dataItem.xInterval = 1.0
        dataItem.yMax = 30.0
        dataItem.yInterval = 2.0
        
        dataItem.axesColor = UIColor.blue
        dataItem.barPointArray = [CGPoint(x: 1.0, y: 0.0), CGPoint(x: 2.0, y: 25.0), CGPoint(x: 3.0, y: 30.0),CGPoint(x: 4.0, y: 25.0), CGPoint(x: 5.0, y: 30.0)]
        dataItem.xAxesDegreeTexts = ["廉政要闻", "消息通知", "提醒事项","紧急通知","紧急事项"]
        
        dataItem.barColor = UIColor.orange
        let barChart: PDBarChart = PDBarChart(frame: CGRect(x: 0, y: 0, width: self.myView.frame.width - 20, height: self.myView.frame.height),dataItem: dataItem)
        
        self.myView.addSubview(barChart)
        barChart.strokeChart()
        
        
     
        
    
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
