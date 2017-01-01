//
//  mediaViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/30.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class mediaViewController: UIViewController {
    
    var movie:AVPlayer?
    var myTitle:String!
    var myURL:NSURL?
    var myItem:AVPlayerItem?
    var movieView:AVPlayerViewController?
    var mediaObjectId:String?
    

    override func viewDidLoad() {
    
        super.viewDidLoad()
        
               // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        let query = BmobQuery(className: "media")
        query?.whereKey("title", equalTo: self.myTitle)
        query?.findObjectsInBackground({ (array, error) in
            if array != nil {
                for obj in array!{
                    let myObject = obj as! BmobObject
                    let myfile = myObject.object(forKey: "media") as? BmobFile
                    self.mediaObjectId = myObject.objectId
                    self.myURL = NSURL(string: (myfile?.url)!)
                    DispatchQueue.main.async {
                        self.myItem = AVPlayerItem(url: NSURL(string: (myfile?.url)!)as! URL)
                    }
               
                }
            }
            else{
                print("\(error?.localizedDescription)")
            }
        })
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      
        if movieView == nil{
            self.movieView = AVPlayerViewController()
            
            self.movie = AVPlayer(playerItem: self.myItem)
            self.movieView?.player = self.movie
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.moviefinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            
            
            self.present(self.movieView!, animated: true, completion: {
                self.movieView?.player?.play()
            })
            
        }else{
            //点击完成按钮后的动作
            self.movieView?.removeFromParentViewController()
            self.movieView = nil
             _ = self.navigationController?.popViewController(animated: true)

        }
    }
    
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moviefinished(noify: Notification){
        
        NotificationCenter.default.removeObserver(self)
        let user = BmobUser.current()
        if user != nil {
        let userId = user?.objectId
        
        let post = BmobObject(outDataWithClassName: "media", objectId: self.mediaObjectId)
        let relation = BmobRelation()
        relation.add(BmobObject(outDataWithClassName: "_User", objectId: userId))
        post?.add(relation, forKey: "users")
        post?.updateInBackground(resultBlock: { (success, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            }
        })
        }
       
        self.dismiss(animated: true, completion:nil)
        _ = self.navigationController?.popViewController(animated: true)
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
