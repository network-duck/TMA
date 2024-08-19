//
//  TimerViewController.swift
//  TMA
//
//  Created by Joseph Rice on 4/23/24.
//

import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var timerCounting: Bool = false
    var pomodoroDuration: TimeInterval = 25 * 60 // 25 minutes
    var breakDuration: TimeInterval = 5 * 60 // 5 minutes
    var timeRemaining: TimeInterval = 0
    var timer: Timer?
    var isBreakTime: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTimeLabel()
        // Style the buttons
        startStopButton.setTitleColor(UIColor.systemGreen, for: .normal)
        resetButton.setTitleColor(UIColor.systemBlue, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set initial time remaining to 25 minutes
        timeRemaining = pomodoroDuration
        updateTimeLabel()
    }
    
    @IBAction func startStopAction(_ sender: Any) {
        if timerCounting {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    @IBAction func resetAction(_ sender: Any) {
        stopTimer()
        timeRemaining = pomodoroDuration // Reset to 25-minute Pomodoro
        isBreakTime = false // Reset to Pomodoro mode
        updateTimeLabel()
    }
    
    func startTimer() {
        timerCounting = true
        startStopButton.setTitle("STOP", for: .normal)
        startStopButton.setTitleColor(UIColor.red, for: .normal)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timerCounting = false
        startStopButton.setTitle("START", for: .normal)
        startStopButton.setTitleColor(UIColor.systemGreen, for: .normal)
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateTimer() {
        if timeRemaining <= 0 {
            stopTimer()
            if isBreakTime {
                // End of break, start new Pomodoro
                isBreakTime = false
                timeRemaining = pomodoroDuration
            } else {
                // End of Pomodoro, start break
                isBreakTime = true
                timeRemaining = breakDuration
            }
            updateTimeLabel()
            return
        }
        timeRemaining -= 1
        updateTimeLabel()
    }
    
    func updateTimeLabel() {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}
