//
//  adminDetailViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/3.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class adminDetailViewController: UIViewController {
    
    var adminTitle: String?
    var adminDate: NSDate?
    var adminContent: String?
    var adminName: String?
    var id: String?
    
    @IBOutlet weak var chineseName: UILabel!
    
    @IBOutlet weak var alarmConten: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "事项内容"
        alarmConten.backgroundColor = UIColor.clear

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let userQuery = BmobQuery(className: "alarm")
        userQuery?.includeKey("author")
        userQuery?.getObjectInBackground(withId: id, block: { (obj, error) in
            
            if let user = obj?.object(forKey: "author"){
                let author = user as! BmobUser
                let chineseName = author.object(forKey: "chinesename") as! String
                DispatchQueue.main.async {
                    self.chineseName.text = chineseName
                self.alarmConten.text = self.adminContent
                }
            }
        })
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

}
