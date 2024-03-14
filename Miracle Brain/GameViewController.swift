//
//  GameViewController.swift
//  Miracle Brain
//
//  Created by KIBEOM SHIN on 3/10/24.
//

import UIKit

enum Level: String {
    case beginner = "초급"
    case intermediate = "중급"
    case advanced = "고급"
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var firstNumLabel: UILabel!
    @IBOutlet weak var secondNumLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var operationImage: UIImageView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var mode: String?
    var levelOption: String?
    var range: Int = 0
    var question: Int = 0
    var timer: Timer?
    var secondsRemaining = 60
    
    // 이미지 이름과 레벨 범위 딕셔너리
    let imageName: [String: String] = [
        "더하기": "plus",
        "빼기": "minus",
        "곱하기": "multiply"
    ]
    let levelRange: [String: ClosedRange<Int>] = [
        "초급": 2...9,
        "중급": 10...99,
        "고급": 100...999
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mode = mode, let levelOption = levelOption else { return }
        
        // 이미지 스타일 적용
        applyImageStyle(mode)
        // 초기 숫자 설정
        setRandomNumbers(mode, levelOption)
        // 버튼 스타일 설정
        resetBtn.layer.cornerRadius = 15
        enterBtn.layer.cornerRadius = 15
        
        // 라벨 스타일 설정
        firstNumLabel.textColor = .black
        secondNumLabel.textColor = .black
        
        startTimer()
    }
    
    // MARK: 계산 기능 함수 정의
    // 연산 기호 이미지 설정 함수 정의
    func applyImageStyle(_ mode: String) {
        if let imageName = imageName[mode] {
            operationImage.image = UIImage(systemName: imageName)
        }
    }
    
    // 숫자 설정 함수 정의
    func setRandomNumbers(_ mode: String, _ levelOption: String) {
        guard let range = levelRange[levelOption], let level = Level(rawValue: levelOption) else { return }
        var firstNum: Int = 0
        var secondNum: Int = 0
        
        switch level {
        case .beginner:
            firstNum = Int.random(in: range)
            secondNum = Int.random(in: range)
        case .intermediate:
            firstNum = Int.random(in: range)
            secondNum = Int.random(in: range)
        case .advanced:
            firstNum = Int.random(in: range)
            secondNum = Int.random(in: range)
        }
        
        while mode == "빼기" && secondNum > firstNum {
            secondNum = Int.random(in: range)
        }
        
        firstNumLabel.text = String(firstNum)
        secondNumLabel.text = String(secondNum)
    }
    
    // 숫자 버튼 클릭 이벤트 핸들러
    @IBAction func clickNumBtn(_ sender: UIButton) {
        if let digit = sender.currentTitle, let answer = answerLabel.text, answer != "0" {
            answerLabel.text = answer + digit
        } else {
            answerLabel.text = sender.currentTitle
        }
    }
    
    // 숫자 지우기 버튼 클릭 이벤트 핸들러
    @IBAction func deleteNumBtn(_ sender: UIButton) {
        guard let answer = answerLabel.text else { return }
        
        if answer.count > 1 {
            answerLabel.text = String(answer.dropLast())
        } else {
            answerLabel.text = "0"
        }
    }
    
    // 결과 버튼 클릭 이벤트 핸들러
    @IBAction func equalNumBtn(_ sender: UIButton) {
        
        guard let mode = mode,
              let first = Int(firstNumLabel.text ?? ""),
              let second = Int(secondNumLabel.text ?? ""),
              let answer = Int(answerLabel.text ?? "") else {
            return
        }
        
        let result: Bool
        
        switch mode {
        case "더하기":
            result = first + second == answer
        case "빼기":
            result = first - second == answer
        case "곱하기":
            result = first * second == answer
        default:
            result = false
        }
        
        if result {
            setRandomNumbers(mode, levelOption ?? "")
            question += 1
        } else {
        }
        answerLabel.text = "0"
    }
    
    // MARK: 타이머 함수 정의
    func startTimer() {
        // 타이머가 이미 실행 중인 경우 먼저 중지
        stopTimer()
        
        // 타이머 설정
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            timerLabel.text = timeString(time: TimeInterval(secondsRemaining))
            if timerLabel.text == "10" {
                timerLabel.textColor = .red
            }
        } else {
            // 타이머 종료
            stopTimer()
            showAlert()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // 초를 시간 형식(00:00)의 문자열로 변환
    func timeString(time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        return String(format: "%02d", seconds)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "게임 종료", message: "총 \(question) 문제 맞혔습니다.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.navigateToMainViewController()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    private func navigateToMainViewController() {
        guard let mainVC = storyboard?.instantiateViewController(withIdentifier: "Main") as? MainViewController else { return }
        mainVC.modalTransitionStyle = .crossDissolve
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
    }
    
    @IBAction func clickEndBtn(_ sender: UIButton) {
        navigateToMainViewController()
    }
}
