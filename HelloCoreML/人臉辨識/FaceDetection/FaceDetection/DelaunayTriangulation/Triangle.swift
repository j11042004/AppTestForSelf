//
//  Triangle.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

import CoreGraphics
import UIKit
/// A simple struct representing 3 vertices
public class Triangle : NSObject {
    public let vertex1: Vertex
    public let vertex2: Vertex
    public let vertex3: Vertex
    
    public init(vertex1: Vertex, vertex2: Vertex, vertex3: Vertex) {
        self.vertex1 = vertex1
        self.vertex2 = vertex2
        self.vertex3 = vertex3
    }
    
    public func v1() -> CGPoint {
        return vertex1.pointValue()
    }
    public func v2() -> CGPoint {
        return vertex2.pointValue()
    }
    public func v3() -> CGPoint {
        return vertex3.pointValue()
    }
    /// 繪製 三角形 路線
    ///
    /// - Returns: 繪製完成的路線
    public func path() -> CGPath{
        // 繪製三角形
        let path = CGMutablePath()
        let point1 = self.vertex1.pointValue()
        let point2 = self.vertex2.pointValue()
        let point3 = self.vertex3.pointValue()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point1)
        path.closeSubpath()
        return path
    }
}
