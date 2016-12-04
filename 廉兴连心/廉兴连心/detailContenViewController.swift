//
//  detailContenViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/13.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class detailContenViewController: UIViewController {
    @IBOutlet weak var content: UITextView!
    
    @IBOutlet weak var contentTitle: UILabel!

    
    @IBOutlet weak var username: UILabel!
    
    var myContent: String!
    var author: String!
    var mytitle: String!
    var myObjectId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTitle.adjustsFontSizeToFitWidth = true
        username.adjustsFontSizeToFitWidth = true
        content.backgroundColor = UIColor.clear
        
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
   
        self.contentTitle.text = mytitle
        
        let query = BmobQuery(className: "bake")
        query?.whereKey("liantitle", equalTo: self.mytitle)
        
        query?.findObjectsInBackground({ (array, error) in
            
            
            if array != nil {
                for obj in array! {
                    
                    
                    
                    let selectedObject = obj as! BmobObject
                    
                    
                    let content = selectedObject.object(forKey: "content")
                    self.myObjectId = selectedObject.objectId
                    
                    query?.includeKey("author")
                    query?.getObjectInBackground(withId: self.myObjectId, block: { (obj, error) in
                        if let usr = obj?.object(forKey: "author") {
                            let myAuthor = usr as! BmobUser
                            self.author = myAuthor.username
                            
                           
                            DispatchQueue.main.async {
                                self.username.text = self.author
                                
                                self.myContent = content as! String
                                 self.content.text = self.myContent                            }
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



}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


