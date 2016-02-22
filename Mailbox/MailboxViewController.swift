//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Hannah Peckham on 2/18/16.
//  Copyright © 2016 Hannah Peckham. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var archiveIconView: UIImageView!
    @IBOutlet weak var laterIconView: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    
    var messageOriginalCenter: CGPoint!
    var messageOffset: CGFloat!
    var messageOffsetLeft: CGFloat!
    var messageLeft: CGPoint!
    var messageRight: CGPoint!
    var archiveOriginalCenter: CGPoint!
    var laterOriginalCenter: CGPoint!
    var feedOriginalCenter: CGPoint!

    let green = UIColor(red: 112/255, green: 217/255, blue: 98/255, alpha: 1)
    let gray = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1)
    let red =  UIColor(red: 235/255, green: 84/255, blue: 51/255, alpha: 1)
    let yellow = UIColor(red: 251/255, green: 211/255, blue: 51/255, alpha: 1)
    let brown = UIColor(red: 216/255, green: 166/255, blue: 117/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: 320, height: 1300)
        
        messageOffset = 320
        messageOffsetLeft = -320
        messageLeft = CGPoint(x: messageView.center.x + messageOffsetLeft ,y: messageView.center.y)
        messageRight = CGPoint(x: messageView.center.x + messageOffset ,y: messageView.center.y)
        
        // Do any additional setup after loading the view.
        
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    

    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)

        
        if sender.state == UIGestureRecognizerState.Began {
            archiveOriginalCenter = archiveIconView.center
            laterOriginalCenter = laterIconView.center
            messageOriginalCenter = messageView.center
            coloredView.backgroundColor = gray
            
        } else if sender.state == UIGestureRecognizerState.Changed{
           
            messageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            
            // First move icon if necessary
            
            let archiveIconThreshold:CGFloat = 60
            let laterIconThreshold:CGFloat = -60
            
            if(translation.x > archiveIconThreshold) {
                archiveIconView.center = CGPoint(x: archiveOriginalCenter.x + (translation.x - archiveIconThreshold),
                    y:archiveOriginalCenter.y)
            }
            
            if(translation.x < laterIconThreshold) {
                laterIconView.center = CGPoint(x: laterOriginalCenter.x + (translation.x - laterIconThreshold),
                    y:laterOriginalCenter.y)
            }
            
            // Now handle color and image changes
            
            if (translation.x >= 260) {
                // change icon to delete and bg to red
                self.coloredView.backgroundColor = self.red
                self.archiveIconView.image = UIImage(named: "delete_icon")

                
            } else if translation.x <= -260 {
                // "Later icon" ?
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.coloredView.backgroundColor = self.brown
                    self.laterIconView.image = UIImage(named: "list_icon")
                    self.archiveIconView.alpha = 0
                    
                })
                
            } else if(translation.x >= 60) {
                self.coloredView.backgroundColor = self.green
                self.archiveIconView.image = UIImage(named: "archive_icon")
                
            } else if translation.x <= -60 {
                // "Later icon" ?
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.coloredView.backgroundColor = self.yellow
                    self.laterIconView.image = UIImage(named: "later_icon")
                    
                    
                })
                
            }
            
            
        } else if sender.state == UIGestureRecognizerState.Ended{
            
            
            if translation.x >= 260 {
                // Delete icon showing
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.center = self.messageRight
                    self.coloredView.backgroundColor = self.red
                    
                })
            } else if translation.x >= 60 {
                // Check showing
                 self.messageView.center = self.messageRight
                
            } else if translation.x <= -260 {
                // "Later icon" ?
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.center = self.messageLeft
                    self.coloredView.backgroundColor = self.brown
                    
                    }, completion: { (_) -> Void in
                        // DO your thang
                        self.rescheduleView.alpha = 1
                        
                })
                
            } else if translation.x <= -60 {
                // "Later icon" ?
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.center = self.messageLeft
                    self.coloredView.backgroundColor = self.yellow
                    
                })

            } else {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                // Nothing should happen. Snap back to original
                self.archiveIconView.center = self.archiveOriginalCenter
                self.messageView.center = self.messageOriginalCenter
                    })
            }
            
            
            
        }

    }
    
    
    @IBAction func didTapReschedule(sender: UITapGestureRecognizer) {
            rescheduleView.alpha = 0
        
        UIView.animateWithDuration(0.3, animations: {
            self.feedView.center.y -= self.messageView.bounds.height})
        self.messageView.alpha = 0
        self.coloredView.alpha = 0
        self.archiveIconView.alpha = 0
        self.laterIconView.alpha = 0
        
       
        }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
