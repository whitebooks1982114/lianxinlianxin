//
//  DetailSendContentViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/24.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class DetailSendContentViewController: UIViewController {
    @IBOutlet weak var detailSentTitle: UILabel!
    
    @IBOutlet weak var detailSendContent: UITextView!
    
    var detailTitle = ""
    
    var detailContent = ""
    
    var myObjectId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailSentTitle.adjustsFontSizeToFitWidth = true
        detailSendContent.backgroundColor = UIColor.clear

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        detailSentTitle.text = detailTitle
        let query = BmobQuery(className: "report")
        query?.whereKey("title", equalTo: self.detailTitle)
        
        query?.findObjectsInBackground({ (array, error) in
            
            
            if array != nil {
                for obj in array! {
                    
                    
                    
                    let selectedObject = obj as! BmobObject
                    
                    
                    let content = selectedObject.object(forKey: "content")
                    self.myObjectId = selectedObject.objectId
                    
                    query?.includeKey("author")
                    query?.getObjectInBackground(withId: self.myObjectId, block: { (obj, error) in
                        
                        DispatchQueue.main.async {
                        self.detailContent = content as! String
                        self.detailSendContent.text = self.detailContent
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
