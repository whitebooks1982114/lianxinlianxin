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
    

    override func viewDidLoad() {
        super.viewDidLoad()
      

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let myGroup = DispatchGroup()
        let myQueue = DispatchQueue(label: "myQueue")
          myQueue.async(group: myGroup, qos: .default, flags: [], execute:
           {
            let query = BmobQuery(className: "bake")
            query?.whereKey("liantitle", equalTo: self.myTitle)
            query?.findObjectsInBackground({ (array, error) in
                if array != nil {
                    for obj in array!{
                        let myObject = obj as! BmobObject
                        let myfile = myObject.object(forKey: "media") as? BmobFile
                        self.myURL = NSURL(string: (myfile?.url)!)
                        self.myItem = AVPlayerItem(url: self.myURL as! URL)
                    }
                }
                else{
                    print("\(error?.localizedDescription)")
                }
            })
            
           
            
        })
        
        myQueue.async {
            if self.movie == nil {
                
            
                self.movie = AVPlayer(playerItem: self.myItem)
             
                NotificationCenter.default.addObserver(self, selector: #selector(self.moviefinished), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                
                
            }
           
                    self.movie?.play()
         
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moviefinished(noify: Notification){
        NotificationCenter.default.removeObserver(self)
        self.movie?.pause()
       // self.movie.view.removeFromSuperview()
        self.movie = nil
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
