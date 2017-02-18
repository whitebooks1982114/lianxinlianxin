//
//  reportViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/24.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class reportViewController: UIViewController {
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func send(_ sender: UIBarButtonItem) {
          }
    
    @IBOutlet weak var newMailWarning: UIImageView!
    
    @IBOutlet weak var newSendWarning: UIImageView!
    
    @IBAction func toMailBox(_ sender: UITapGestureRecognizer) {
    }
    
    @IBAction func toSendBox(_ sender: UITapGestureRecognizer) {
    }
    
    @IBOutlet weak var mailBoxView: UIView!
    
    @IBOutlet weak var sendBoxView: UIView!
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let query = BmobQuery(className: "report")
        let query1  = BmobQuery(className: "report")
        let query2 = BmobQuery(className: "report")
        let mainquery = BmobQuery(className: "report")
        
        let user = BmobUser.current()
        
        let userID = user?.objectId
        let author = BmobUser(outDataWithClassName: "_User", objectId: userID)
        query?.whereKey("author", equalTo: author)
        query1?.whereKey("readed", equalTo: false)
        query2?.whereKey("adminsend", equalTo: true)
        mainquery?.add(query)
        mainquery?.add(query1)
        mainquery?.add(query2)
        mainquery?.andOperation()
        mainquery?.countObjectsInBackground({ (count, error) in
            DispatchQueue.main.async {
                if count != 0 {
                    self.newMailWarning.image = #imageLiteral(resourceName: "inboxnew")
                }else {
                    self.newMailWarning.image = #imageLiteral(resourceName: "inbox")
                }
       
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
