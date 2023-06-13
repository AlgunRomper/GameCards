//
//  ViewController.swift
//  Cards
//
//  Created by Новый пользователь  on 11.05.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        self.view = view
        
        //        view.layer.addSublayer(CircleShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.gray.cgColor))
        
        //        view.layer.addSublayer(CrossShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.gray.cgColor))
        //        view.layer.addSublayer(FillShape(size: CGSize(width: 200, height: 150), fillColor: UIColor.gray.cgColor))
        //        view.layer.addSublayer(BackSideCircle(size: CGSize(width: 100, height: 50), fillColor: UIColor.gray.cgColor))
        //        view.layer.addSublayer(BackSideLine(size: CGSize(width: 100, height: 50), fillColor: UIColor.gray.cgColor))
        
        //игральная карточка рубашкой вверх
        let firstCardView = CardView<CircleShape>(frame: CGRect(x: 0, y: 0, width: 70, height: 90), color: .green)
        self.view.addSubview(firstCardView)
        firstCardView.flipCompletionHandler = { card in
            card.superview?.bringSubviewToFront(card)
        }
        
        //игральная карточка лицевой стороной вверх
        let secondCardView = CardView<CircleShape>(frame: CGRect(x: 200, y: 0, width: 70, height: 90), color: .blue)
        self.view.addSubview(secondCardView)
        secondCardView.isFlipped = true
        secondCardView.flipCompletionHandler = { card in
            card.superview?.bringSubviewToFront(card)
        }
    }
}
