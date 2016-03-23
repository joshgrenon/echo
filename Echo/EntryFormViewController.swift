//
//  EntryFormViewController.swift
//  Echo
//
//  Created by Isis Anchalee on 3/7/16.
//  Copyright © 2016 echo. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class EntryFormViewController: UIViewController {
    var video: NSURL?
    var thumbnail: NSData?
    
    @IBOutlet weak var privateSwitch: UISwitch!
    @IBOutlet weak var entryThumbnailImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var songTextField: UITextField!
    
    @IBOutlet weak var artistIconImageView: UIImageView!
    @IBOutlet weak var songIconImageView: UIImageView!
    @IBOutlet weak var titleIconImageView: UIImageView!
    @IBOutlet weak var artistTextField: UITextField!
    @IBAction func onCancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func generateThumbnail(){
        let asset = AVURLAsset(URL: video!, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        var uiImage: UIImage?
        do {
            let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
            uiImage = UIImage(CGImage: cgImage)
        } catch {
            uiImage = UIImage(named: "sea-otter")
        }
        entryThumbnailImageView.image = uiImage
        thumbnail = UIImagePNGRepresentation(uiImage!)
    }
    
    func setupIcons() {
        artistIconImageView.image = UIImage(named: "Artist Icon")
        songIconImageView.image = UIImage(named: "Music Icon")
        titleIconImageView.image = UIImage(named:"Title Icon")
    }
    
    
    @IBAction func onTap(sender: AnyObject) {
         dismissKeyboard()
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onEntrySave(sender: AnyObject) {
        let user_id = currentUser!.id
        let username =  currentUser!.username
        let title = titleTextField.text
        let song = songTextField.text
        var responseDict: [String: NSObject] = Dictionary<String,NSObject>()
        let videoData = NSData(contentsOfURL: video!)
        let videoFile = PFFile(name: "Entry.mov", data: videoData!)
        let thumbnailFile = PFFile(name: "Thumbnail.png", data: thumbnail!)
        
        responseDict["username"] = username
        responseDict["user_id"] = user_id
        responseDict["title"] = title
        responseDict["song"] = song
        responseDict["video"] = videoFile
        responseDict["thumbnail"] = thumbnailFile
        responseDict["artist"] = artistTextField.text
        if privateSwitch.on {
            responseDict["private"] = true
        } else {
            responseDict["private"] = false
        }
        
        ParseClient.sharedInstance.createEntryWithCompletion(responseDict) { (entry, error) -> () in
            let entryStoryBoard = UIStoryboard(name: "Entry", bundle: nil)
            let entryViewController = entryStoryBoard.instantiateViewControllerWithIdentifier("EntryViewController") as! EntryViewController
            entryViewController.entry = entry
            entryViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "entryDoneButtonTapped:")
            self.navigationController?.pushViewController(entryViewController, animated: true)

        }
    }
    
    func entryDoneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        generateThumbnail()
        setupIcons()
        privateSwitch.onTintColor = StyleGuide.Colors.echoBorderGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
