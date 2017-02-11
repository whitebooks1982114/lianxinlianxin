//
//  noticedetailViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/18.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit


class noticedetailViewController: UIViewController {
    
    var mytitle: String?
    var cutDownTime: NSDate?
    var myNoticeContent: String?
   
   
    
    @IBOutlet weak var content: UITextView!
    
    @IBOutlet weak var remainDays: UILabel!
    
   
   
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "通知消息"
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        content.text = myNoticeContent
        content.backgroundColor = UIColor.clear
        noticeArrayIsNotNull = false
    
        let oneDay = 86400
        
        let myremainDays = Int((cutDownTime?.timeIntervalSinceNow)!) / oneDay + 1
        
        remainDays.text = "剩余\(myremainDays)天"
        
        if myremainDays < 2 && myremainDays > 0 {
            
            remainDays.textColor = UIColor.red
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.autoreverse,.curveEaseIn,.repeat], animations: {
                self.remainDays.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: nil)
            
            
        }else if myremainDays <= 0 {
            
            remainDays.text = "剩余0天"
            
        }
        
              
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
}
