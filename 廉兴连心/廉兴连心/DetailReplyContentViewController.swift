//
//  DetailReplyContentViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/24.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class DetailReplyContentViewController: UIViewController {

    @IBOutlet weak var replyTitleLabel: UILabel!
    
    @IBOutlet weak var replyContentTextView: UITextView!
    
    var replyTitle = ""
    var replyContent = ""
     var myObjectId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "详细信息"
        replyTitleLabel.adjustsFontSizeToFitWidth = true
        replyContentTextView.backgroundColor = UIColor.clear

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        replyTitleLabel.text = replyTitle
        let query = BmobQuery(className: "report")
        query?.whereKey("replytitle", equalTo: self.replyTitle)
        
        query?.findObjectsInBackground({ (array, error) in
  
            if array != nil {
                for obj in array! {
             
                    let selectedObject = obj as! BmobObject
                    
                    
                    let content = selectedObject.object(forKey: "reply")
                    self.myObjectId = selectedObject.objectId
                    
                    query?.includeKey("author")
                    query?.getObjectInBackground(withId: self.myObjectId, block: { (obj, error) in
                        
                        DispatchQueue.main.async {
                            self.replyContent = content as! String
                            self.replyContentTextView.text = self.replyContent
                        }
                        
                    })
                    
                    
                }
                
            } else {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误提示", message: "服务器连接失败", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        })
        
        

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
