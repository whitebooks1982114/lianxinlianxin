//
//  newsdetailViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/18.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class newsdetailViewController: UIViewController {

    @IBOutlet weak var newsImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "要闻内容"
        
        newsImage.isHidden = true

        // Do any additional setup after loading the view.
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
