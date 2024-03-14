//
//  SplashViewController.swift
//  Miracle Brain
//
//  Created by KIBEOM SHIN on 3/10/24.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 애니메이션 설정
        let animation = LottieAnimation.named("star")
        let animationView = LottieAnimationView(animation: animation)
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = view.center
        
        view.addSubview(animationView)
        
        // 애니메이션 종료 후 뷰컨트롤러 이동
        animationView.play(completion: { finished in
            if finished {
                self.navigateToMainViewController()
            }
        })
    }
    
    private func navigateToMainViewController() {
        guard let mainVC = storyboard?.instantiateViewController(withIdentifier: "Main") as? MainViewController else { return }
        mainVC.modalTransitionStyle = .coverVertical
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
    }
}

