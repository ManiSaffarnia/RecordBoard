//
//  RecordViewController.swift
//  RecordBoard
//
//  Created by mani saffarnia on 2/5/18.
//  Copyright © 2018 mani saffarnia. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordNameTextfield: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if audioRecorder == nil{
            addButton.isEnabled = false
            playButton.isEnabled = false
        }
        
        setupAudioRecorder()
    }

    
    //==================================================
    //=          Setting up the audio recorder         =
    //==================================================
    func setupAudioRecorder(){
        
        do{
        //Step 1: create a session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord) //mode zabt kardan chetor bash
            try session.overrideOutputAudioPort(.speaker) //seda az koja pakhsh beshe
            try session.setActive(true)
            
            
        //Step 2: Create url for audio file
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)
            
            //print(audioURL)
            
        //Step 3: Create setting for the audio recorder
        
            var settings: [String:Int] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100
            settings[AVNumberOfChannelsKey] = 2
        
        //Step 4: Create audio recorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            
            
        //Step 5:prepare for record
            audioRecorder?.prepareToRecord()
            
        }//end do
        catch{
            
        }//end catch
        
        
    }//end function
    
    
    //==================================================
    //=                  Record button                 =
    //==================================================
    @IBAction func recordButtonPushed(_ sender: UIButton) {
        
        if audioRecorder!.isRecording{
            audioRecorder?.stop()
            recordButton.setTitle("Record", for: .normal) //update button title
            playButton.isEnabled = true
            addButton.isEnabled = true
        }else{
            audioRecorder?.record()
            recordButton.setTitle("Stop", for: .normal) //update button title
            
        }
    }
    
    
    
    //==================================================
    //=                  play button                   =
    //==================================================
    @IBAction func playButtonPushed(_ sender: UIButton) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer?.play()
        }catch{
            
        }
    }
    
    
    
    
    //==================================================
    //=                    add button                  =
    //==================================================
    @IBAction func addButtonPushed(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newVoice = Record(context: context)
        newVoice.title = recordNameTextfield.text
        newVoice.voice = NSData.init(contentsOf: audioURL!) as Data?
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
}//end
