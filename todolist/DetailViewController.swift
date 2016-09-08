//
//  DetailViewController.swift
//  todolist
//
//  Created by David Ng on 8/9/2016.
//  Copyright © 2016 SkygearIO. All rights reserved.
//

import UIKit
import SKYKit

class DetailViewController: UIViewController {
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem as? SKYRecord {
            if let titleLabel = self.titleField {
                titleLabel.text = detail.objectForKey("title") as? String
            }
            if let descLabel = self.descField {
                descLabel.text = detail.objectForKey("desc") as? String
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
