//
//  ViewController.swift
//  RecordBoard
//
//  Created by mani saffarnia on 2/5/18.
//  Copyright © 2018 mani saffarnia. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var audioPlayer : AVAudioPlayer?
    var records: [Record] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try records = context.fetch(Record.fetchRequest())
        }catch{}
        tableView.reloadData()
    }
    
    //============================================
    //             setup table view              =
    //============================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = records[indexPath.row].title
        return cell
    }
    
    //============================================
    //        table select row to play           =
    //============================================
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            let selectedVoice = records[indexPath.row]
            try audioPlayer = AVAudioPlayer(data: selectedVoice.voice!)
            audioPlayer?.play()
            tableView.deselectRow(at: indexPath, animated: true)
        }catch{
            
        }
        
    }
    
    
    //============================================
    //              delete a voice               =
    //============================================
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(records[indexPath.row])
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do{
                try records = context.fetch(Record.fetchRequest())
            }catch{}
            tableView.reloadData()
        }
    }
    
    //end

}

