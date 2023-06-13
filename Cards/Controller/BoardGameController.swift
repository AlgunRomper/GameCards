//
//  BoardGameController.swift
//  Cards
//
//  Created by Новый пользователь  on 01.06.2023.
//

import UIKit

class BoardGameController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //количество пар уникальных карточек
    var cardsPairsCounts = 8
    //сущность игра
    lazy var game: Game = getNewGame()
    
    private func getNewGame() -> Game {
        let game = Game()
        game.cardsCount = self.cardsPairsCounts
        game.generateCards()
        return game
    }

    //кнопка для запуска/перезапуска игры
    lazy var startButtonView = getStartButtonView()
    
    private func getStartButtonView() -> UIButton {
        //создаем кнопку
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        //изменяем положение кнопки
        button.center.x = view.center.x
        
        //получаем доступ к текущему окну
        let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = firstScene?.windows[0]
        //определяем отступ сверху от границ окна до safe Area
        let topPadding = window?.safeAreaInsets.top
        //устанавливаем координату Y кнопки в соответствии с отступом
        button.frame.origin.y = topPadding ?? 0
        
        //настраиваем внешний вид кнопки
        
        //устанавливаем текст
        button.setTitle("Начать игру", for: .normal)
        //устанавливаем цвет текста для обычного не нажаьтого состояния
        button.setTitleColor(.black, for: .normal)
        //устанавливаем цвет текста для нажатого состояния
        button.setTitleColor(.gray, for: .highlighted)
        //устанавливаем фоновый цвет
        button.backgroundColor = .systemGray4
        //скругляем углы
        button.layer.cornerRadius = 10
        
        button.setTitleShadowColor(.black, for: .normal)
        
        //подключаем обработчик нажатия на кнопку
        button.addTarget(nil, action: #selector(startGame), for: .touchUpInside)
        
        return button
    }
    
    @objc func startGame(_ sender: UIButton) {
        game = getNewGame()
        let cards = getCardsBy(modelData: game.cards)
        placeCardsOnBoard(cards)
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(startButtonView)
        view.addSubview(boardGameView)
    }
    
    //MARK: добавляем игровое поле
    
    lazy var boardGameView = getBoardGameView()
    
    private func getBoardGameView() -> UIView {
        
        //отступ игрового поля от ближайших элементов
        let margin: CGFloat = 10
        
        let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = firstScene?.windows[0]
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        let boardView = UIView()
        
        //указываем координаты
        boardView.frame.origin.x = margin

        boardView.frame.origin.y = startButtonView.frame.height + margin + topPadding
        
        //расчитываем ширину
        boardView.frame.size.width = (view.window?.windowScene?.screen.bounds.width ?? view.frame.width) - margin*2
                               
        //расчитываем высоту
//        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
        boardView.frame.size.height = (view.window?.windowScene?.screen.bounds.height ?? view.frame.height) - boardView.frame.origin.y - margin - bottomPadding
        
        //изменяем стиль игрового поля
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
        
        return boardView
    }
    
    //MARK: размещаем карточки на игровом поле
    private func getCardsBy(modelData: [Card]) -> [UIView] {
        var cardViews = [UIView]()
        
        //фабрика карточек
        let cardViewFactory = CardViewFactory()
        //перебираем массив карточек в Модели
        for (index, modelCard) in modelData.enumerated() {
            //добавляем первый экземпляр карты
            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardOne.tag = index
            cardViews.append(cardOne)
            
            //добавляем второй экземпляр карты
            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardTwo.tag = index
            cardViews.append(cardTwo)
        }
        
        for card in cardViews {
            (card as! FlippableViewProtocol).flipCompletionHandler = { flippedCard in
                //переносим карточку вверх иерархии
                flippedCard.superview?.bringSubviewToFront(flippedCard)
            }
        }
        
        //добавляем всем карточкам обработчик переворота
        for card in cardViews {
            (card as! FlippableViewProtocol).flipCompletionHandler = { [self] flippedCard in
                //переносим карточку вверх иерархии
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                //доабвляем или удаляем карточку
                if flippedCard.isFlipped {
                    self.flippedCards.append(flippedCard)
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
                
                //если перевернуто 2 карточки
                if self.flippedCards.count == 2 {
                    //получаем карточки из данных модели
                    let firstCard = game.cards[self.flippedCards.first!.tag]
                    let secondCard = game.cards[self.flippedCards.last!.tag]
                    
                    //если карточки одинаковые
                    if game.checkCards(firstCard, secondCard) {
                        //сперва анимированно скрываем их
                        UIView.animate(withDuration: 0.3, animations: {
                            self.flippedCards.first!.layer.opacity = 0
                            self.flippedCards.last!.layer.opacity = 0
                        },
                                       //после чего удаляем их из иерархии
                                       completion: {_ in
                            self.flippedCards.first!.removeFromSuperview()
                            self.flippedCards.last!.removeFromSuperview()
                            self.flippedCards = []
                        })
                        //в ином случае
                    } else {
                        //переворачиваем карточки рубашкой вверх
                        for card in self.flippedCards {
                            (card as! FlippableViewProtocol).flip()
                        }
                    }
                }
            }
        }
        return cardViews
    }
    
    //Размеры карточек
    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
    
    //предельные координаты размещения карточки
    private var cardMaxXCoordinate: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    private var cardMaxYCoordinate: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }
    
    //игральные карточки
    var cardViews = [UIView]()
    
    private func placeCardsOnBoard(_ cards: [UIView]) {
        //удаляем все имеющиеся на игровом поле карточки
        for card in cardViews {
            card.removeFromSuperview()
        }
        cardViews = cards
        //перебираем карточки
        for card in cardViews {
            //для каждой карточки генерируем случайные координаты
            let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            //размещаем карточку на игровом поле
            boardGameView.addSubview(card)
        }
    }
    
    //для перевернутых карточек. когда карточка перевернута рубашкой вниз - она сюда добавляется, а когда переворачивается обратно - удаляется. Это можно будет использовать для проверки на идентичность двух карточек
    private var flippedCards = [UIView]()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
