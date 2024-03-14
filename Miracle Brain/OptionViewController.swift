//
//  OptionViewController.swift
//  Miracle Brain
//
//  Created by KIBEOM SHIN on 3/10/24.
//

import UIKit
import FirebaseAnalytics

class OptionViewController: UIViewController {
    
    @IBOutlet weak var explanLabel: UILabel!
    @IBOutlet weak var levelPickerView: UIPickerView!
    @IBOutlet weak var startBtn: UIButton!
    
    var mode: String?
    let levelOption: [String] = ["초급", "중급", "고급"]
    var level: String = "초급"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelPickerView.delegate = self
        levelPickerView.dataSource = self
        
        self.startBtn.layer.cornerRadius = 20
        self.startBtn.layer.shadowColor = UIColor.gray.cgColor
        self.startBtn.layer.shadowOpacity = 1.0
        self.startBtn.layer.shadowOffset = CGSize.zero
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let screenData: [String: String] = [
            AnalyticsParameterScreenName: "옵션 화면",
            "ep_platform": "APP",
        ]
        
        Analytics.setUserProperty(Analytics.appInstanceID(), forName: "up_cid")
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenData)
    }
    
    @IBAction func clickStartBtn(_ sender: UIButton) {
        let eventData: [String: String] = [
            "ep_platform": "APP",
            "ep_category": "버튼 클릭",
            "ep_area": "시작 버튼"
        ]
        
        Analytics.logEvent("click_event", parameters: eventData)
        navigateToGameViewController()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "gameStart" {
//            let VC = segue.destination as! GameViewController
//            VC.levelOption = level
//            VC.mode = mode
//        }
//    }
    
    private func navigateToGameViewController() {
        guard let gameVC = storyboard?.instantiateViewController(withIdentifier: "Game") as? GameViewController else { return }
        gameVC.modalTransitionStyle = .partialCurl
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.levelOption = level
        gameVC.mode = mode
        present(gameVC, animated: true, completion: nil)
    }
}

extension OptionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: levelOption[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levelOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return levelOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            explanLabel.text = "한 자리수 연산을 실시 합니다."
            level = levelOption[row]
        } else if row == 1 {
            explanLabel.text = "두 자리수 연산을 실시 합니다."
            level = levelOption[row]
        } else if row == 2 {
            explanLabel.text = "세 자리수 연산을 실시 합니다."
            level = levelOption[row]
        }
    }
}
