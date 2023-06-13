//
//  Shapes.swift
//  Cards
//
//  Created by Новый пользователь  on 01.06.2023.
//

import UIKit

protocol ShapeLayerProtocol: CAShapeLayer {
    init(size: CGSize, fillColor: CGColor)
}

extension ShapeLayerProtocol {
    init() {
        fatalError("init() не может быть использован для создания экзепляра")
    }
}

class CircleShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        //расчитываем данные для круга
        //радиус равен половине меньшей из сторон
        let radius = ([size.width, size.height].min() ?? 0) / 2
        //центр круга равен центрам каждой из сторон
        let centerX = size.width / 2
        let centerY = size.height / 2
        
        //рисуем круг
        let path = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
        path.close()
        //инициируем созданный путь
        self.path = path.cgPath
        //изменяем цвет
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CrossShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        //рисуем крест
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.move(to: CGPoint(x: size.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: size.height))
        
        //инициализируем созданный путь
        self.path = path.cgPath
        //изменяем цвет
        self.strokeColor = fillColor
        self.lineWidth = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SquareShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let edgeSize = ([size.width, size.height].min() ?? 0)
        let rect = CGRect(x: 0, y: 0, width: edgeSize, height: edgeSize)
        let path = UIBezierPath(rect: rect)
        self.path = path.cgPath
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FillShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.path = path.cgPath
        self.fillColor = fillColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BackSideCircle: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let path = UIBezierPath()
        
        //рисуем 15 кругов
        for _ in 1...15 {
            //координаты центра очередного круга
            let randomX = Int.random(in: 1...Int(size.width))
            let randomY = Int.random(in: 1...Int(size.height))
            let center = CGPoint(x: randomX, y: randomY)
            //смещаем указатель к центру круга
            path.move(to: center)
            //определяем случайный радиус
            let radius = Int.random(in: 1...15)
            //рисуем круг
            path.addArc(withCenter: center, radius: CGFloat(radius), startAngle: 0, endAngle: .pi*2, clockwise: true)
        }
        //инициализируем созданный путь
        self.path = path.cgPath
        //изменяем цвет
        self.strokeColor = fillColor
        self.fillColor = fillColor
        self.lineWidth = 1
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BackSideLine: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let path = UIBezierPath()
        
        for _ in 1...15 {
            let randomXStart = Int.random(in: 1...Int(size.width))
            let randomYStart = Int.random(in: 1...Int(size.height))
            let randomXFinish = Int.random(in: 1...Int(size.width))
            let randomYFinish = Int.random(in: 1...Int(size.height))
            //смещаем указатель к началу линии
            path.move(to: CGPoint(x: randomXStart, y: randomYStart))
            //рисуем линию
            path.addLine(to: CGPoint(x: randomXFinish, y: randomYFinish))
        }
        //инициализируем созданный путь
        self.path = path.cgPath
        //изменяем цвет
        self.strokeColor = fillColor
        self.lineWidth = 3
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
