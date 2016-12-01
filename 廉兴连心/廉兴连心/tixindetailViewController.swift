//
//  tixindetailViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/17.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class tixindetailViewController: UIViewController {
    
    var myTitle: String?
    var cutDownDate: NSDate?
    var alarmContent: String?
    
    @IBOutlet weak var myAlarmContent: UITextView!
    
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var month: UILabel!
    
    @IBOutlet weak var day: UILabel!
    
    @IBOutlet weak var remainDays: UILabel!
    
  

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "提醒内容"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.myAlarmContent.text = alarmContent
        
        let oneDay = 86400
        
        let dm = DateFormatter()
        dm.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let deadLineString = dm.string(from: cutDownDate as! Date) as NSString
        
        let expireYear = deadLineString.substring(to: 4)
        let expireMonth = deadLineString.substring(with: NSRange(location: 5, length: 2))
        let expireDay = deadLineString.substring(with: NSRange(location: 8, length: 2))
        
        self.year.text = expireYear
        self.month.text = expireMonth
        self.day.text = expireDay
        
        let myremainDays = Int((cutDownDate?.timeIntervalSinceNow)!) / oneDay + 1
        
        remainDays.text = "\(myremainDays)"
        
        if myremainDays < 2 && myremainDays > 0 {
            
            remainDays.textColor = UIColor.red
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.autoreverse,.curveEaseIn,.repeat], animations: {
                self.remainDays.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: nil)

        }else if myremainDays <= 0 {
            
            remainDays.text = "0"
        }

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
