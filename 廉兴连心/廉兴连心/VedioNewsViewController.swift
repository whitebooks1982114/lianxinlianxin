//
//  VedioNewsViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 17/1/31.
//  Copyright © 2017年 whitebooks. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class VedioNewsViewController: UIViewController {
    
    var movie:AVPlayer?
    var myTitle:String!
    var myURL:URL?
    var myItem:AVPlayerItem?
    var movieView:AVPlayerViewController?
    var mediaObjectId:String?


    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if movieView == nil{
            self.myItem = AVPlayerItem(url: self.myURL!)
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
