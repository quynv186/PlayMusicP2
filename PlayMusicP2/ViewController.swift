//
//  ViewController.swift
//  PlayMusicP2
//
//  Created by admin on 10/19/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    var audio = AVAudioPlayer()
    var isPlay = false
    var isMute = false
    var time = Timer()
    
    @IBOutlet weak var sld_Volume: UISlider!
    @IBOutlet weak var btn_Play: UIButton!
    @IBOutlet weak var lbl_TimeLeft: UILabel!
    @IBOutlet weak var lbl_TimeRight: UILabel!
    @IBOutlet weak var sld_Duration: UISlider!
    @IBOutlet weak var my_Switch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audio = try! AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "music", ofType: "mp3")!) as URL)
        audio.prepareToPlay()
        
        sld_Duration.value = 0
        sld_Duration.maximumValue = Float(audio.duration)
        
        lbl_TimeRight.text = formatTime(time: Int(audio.duration))
        addThumb()
        
        audio.delegate = self
        
    }
    
    func addThumb() {
        sld_Volume.setThumbImage(UIImage(named: "thumb.png"), for: .normal)
        sld_Volume.setThumbImage(UIImage(named: "thumbHightLight.png"), for: .highlighted)
        sld_Duration.setThumbImage(UIImage(named: "duration.png"), for: .normal)
    }
    
    func setTime() {
        lbl_TimeLeft.text = formatTime(time: Int(audio.currentTime))
        sld_Duration.value = Float(audio.currentTime)
    }
    
    func formatTime(time:Int)-> String {
        var s = ""
        let minute = time / 60
        let second = time % 60
        
        if (minute < 10 && second < 10) {
            s = "0\(minute):0\(second)"
        } else {
            if (second < 10) {
                s = "\(minute):0\(second)"
            } else if (minute < 10) {
                s = "0\(minute):\(second)"
            } else {
                s = "\(minute):\(second)"
            }
        }
        return s
    }
    
    func switchChange() {
        if (my_Switch.isOn) {
            audio.numberOfLoops = -1
        } else {
            audio.numberOfLoops = 0
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if (my_Switch.isOn == false) {
            isPlay = false
            btn_Play.setImage(UIImage(named: "play.png"), for: .normal)
        }
    }
    
    @IBAction func action_Play(_ sender: UIButton) {
        if (isPlay == false) {
            audio.play()
            isPlay = true
            btn_Play.setImage(UIImage(named: "pause.png"), for: .normal)
            time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
            switchChange()
        } else {
            audio.pause()
            isPlay = false
            btn_Play.setImage(UIImage(named: "play.png"), for: .normal)
            time.invalidate()
        }
    }
    
    @IBAction func sld_Volume(_ sender: AnyObject) {
        audio.volume = sld_Volume.value
        isMute = false
    }
    
    @IBAction func sld_Duration(_ sender: AnyObject) {
        audio.currentTime = TimeInterval(sld_Duration.value)
    }


    @IBAction func action_Mute(_ sender: AnyObject) {
        if(isMute == false) {
            audio.volume = 0
            isMute = true
        } else {
            audio.volume = sld_Volume.value
            isMute = false
        }
    }
    
    @IBAction func my_Switch(_ sender: AnyObject) {
        switchChange()
    }
    
}

