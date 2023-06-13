//
//  CardViewFactory.swift
//  Cards
//
//  Created by Новый пользователь  on 05.06.2023.
//

import UIKit

class CardViewFactory {
    func get(_ shape: CardType, withSize size: CGSize, andColor color: CardColor) -> UIView {
        //на основе размеров определяем фрейм
        let frame = CGRect(origin: .zero, size: size)
        //определяем UI-цвет на основе цвета модели
        let viewColor = getViewColorBy(modelColor: color)
        
        
        //генерируем и возвращаем карточку
        switch shape {
        case .circle:
            return CardView<CircleShape>(frame: frame, color: viewColor)
        case .cross:
            return CardView<CrossShape>(frame: frame, color: viewColor)
        case .square:
            return CardView<SquareShape>(frame: frame, color: viewColor)
        case .fill:
            return CardView<FillShape>(frame:  frame, color: viewColor)
        }
    }
    
    private func getViewColorBy(modelColor: CardColor) -> UIColor {
        switch modelColor {
        case .black:
            return .black
        case .red:
            return .red
        case .gray:
            return .gray
        case .brown:
            return .brown
        case .green:
            return .green
        case .orange:
            return .orange
        case .purple:
            return .purple
        case .yellow:
            return .yellow
        }
    }
}
