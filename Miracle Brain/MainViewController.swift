//
//  MainViewController.swift
//  Miracle Brain
//
//  Created by KIBEOM SHIN on 3/10/24.
//

import UIKit
import FirebaseAnalytics

extension UIButton {
    // 버튼 스타일 설정 함수 정의
    func applyBtnStyle() {
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.zero
    }
    
    // 버튼 클릭 이벤트 핸들러
    func addClickAction() {
        self.addTarget(self, action: #selector(btnDown), for: .touchDown)
        self.addTarget(self, action: #selector(btnUp), for: .touchUpInside)
    }
    
    // 버튼 눌렸을 때
    @objc func btnDown() {
        self.layer.shadowOpacity = 0
    }
    
    // 버튼 올라올 때
    @objc func btnUp() {
        self.layer.shadowOpacity = 1.0
    }
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var multiplyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 스타일
        self.plusBtn.applyBtnStyle()
        self.minusBtn.applyBtnStyle()
        self.multiplyBtn.applyBtnStyle()
        
        // 버튼 클릭 이벤트
        self.plusBtn.addClickAction()
        self.minusBtn.addClickAction()
        self.multiplyBtn.addClickAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let screenData: [String: String] = [
            AnalyticsParameterScreenName: "메인 화면",
            "ep_platform": "APP",
        ]
        
        Analytics.setUserProperty(Analytics.appInstanceID(), forName: "up_cid")
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenData)
    }
    
    // 더하기 버튼 클릭 이벤트 핸들러
    @IBAction func clickPlusBtn(_ sender: Any) {
        navigateToOptionViewController("더하기")
    }
    
    // 빼기 버튼 클릭 이벤트 핸들러
    @IBAction func clickMinusBtn(_ sender: Any) {
        navigateToOptionViewController("빼기")
    }
    
    // 곱하기 버튼 클릭 이벤트 핸들러
    @IBAction func clickMultiplyBtn(_ sender: Any) {
        navigateToOptionViewController("곱하기")
    }
    
    private func navigateToOptionViewController(_ mode: String) {
        guard let optionVC = storyboard?.instantiateViewController(withIdentifier: "Option") as? OptionViewController else { return }
        optionVC.mode = mode
        
        let navigationController = UINavigationController(rootViewController: optionVC)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .automatic
        present(navigationController, animated: true, completion: nil)
    }
}
