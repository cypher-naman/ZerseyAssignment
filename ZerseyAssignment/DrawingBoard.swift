//
//  DrawingBoard.swift
//  ZerseyAssignment
//
//  Created by Naman Sharma on 29/06/20.
//  Copyright © 2020 Naman Sharma. All rights reserved.
//

import UIKit

class DrawingBoard:UIView{
    
    var lines = [Line]()
    var colorOfLine = UIColor.black
    func undo(){
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    func clear(){
        lines.removeAll()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        //custom canvas
        super.draw(rect)
        guard  let context = UIGraphicsGetCurrentContext() else {return}
        
        lines.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            for (i,p) in line.points.enumerated(){
                if i == 0 {
                    context.move(to: p)
                }else{
                    context.addLine(to: p)
                }
            }
             context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line.init(color: colorOfLine, points: []))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touches = touches.first?.location(in: nil) else {return}
        guard var recentLine = lines.popLast() else {return}
        recentLine.points.append(touches)
        lines.append(recentLine)
        setNeedsDisplay()
    }
    
}
