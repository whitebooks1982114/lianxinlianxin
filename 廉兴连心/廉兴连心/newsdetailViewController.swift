//
//  newsdetailViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/18.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class newsdetailViewController: UIViewController {

    var newsContent: String! = nil
    
    var newsName:String? = nil
    
    @IBOutlet weak var newsTitle: UILabel!
    
    @IBOutlet weak var news: UITextView!
    
    @IBOutlet weak var newsImage: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "要闻内容"
        self.news.backgroundColor = UIColor.clear

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        newsImage.isHidden = true
 
        self.newsTitle.text = newsName
        
        let query = BmobQuery(className: "news")
        query?.whereKey("title", equalTo: self.newsName)
        
        query?.findObjectsInBackground({ (array, error) in
            
            
            if array != nil {
                for obj in array! {
                    
                    let selectedObject = obj as! BmobObject
                    
                    let newsImageFile = selectedObject.object(forKey: "image") as? BmobFile
                    
                    if newsImageFile != nil {
                        self.newsImage.isHidden = false
                        let url = NSURL(string: (newsImageFile?.url)!)
                        let newsData = NSData(contentsOf: url as! URL)
                
                        self.newsImage.image = UIImage(data: newsData as! Data)
                  
                    }else {
                        self.newsImage.isHidden = true
                        
                    }
                    let content = selectedObject.object(forKey: "content")
                    
                    self.newsContent = content as! String
                    
                    DispatchQueue.main.async {
                        self.news.text = self.newsContent
                        
                    }
                    
                    
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
