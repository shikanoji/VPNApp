//
//  LinearGradientStatus.swift
//  SysVPN (iOS)
//
//  Created by Da Phan Van on 21/02/2022.
//

import SwiftUI

struct LinearGradientStatus: View {
    
    @State var percent: CGFloat = 1
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppColor.darkButton)
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [AppColor.greenGradient, AppColor.yellowGradient, .orange, AppColor.redradient]),
                            startPoint: .leading,
                            endPoint: .trailing)
                    )
                    .clipShape(
                        CustomShape(widthPercent: percent)
                    )
            }
            .frame(width: Constant.StaticIP.widthStatusStatic,
                   height: Constant.StaticIP.heightStatusStatic)
        }
    }
}

struct LinearGradientStatus_Previews: PreviewProvider {
    static var previews: some View {
        LinearGradientStatus()
            .preferredColorScheme(.dark)
    }
}

struct TriangleX: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX / 2, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

struct CustomShape: Shape {
    var widthPercent: CGFloat = 1
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = Constant.StaticIP.widthStatusStatic * widthPercent
        let height = Constant.StaticIP.heightStatusStatic

        let halfHeight = height / 2
        let halfWidth = width / 2
            
        path.move(to: CGPoint(x: halfWidth, y: 0))
        
        path.addLine(to: CGPoint(x: width - halfHeight, y: 0))
        
        path.addCurve(to: CGPoint(x: width, y: halfHeight),
                      control1: CGPoint(x: width, y: 0),
                      control2: CGPoint(x: width, y: halfHeight))
        
        path.addCurve(to: CGPoint(x: width - halfHeight, y: rect.height),
                      control1: CGPoint(x: width, y: halfHeight),
                      control2: CGPoint(x: width, y: rect.height))
        
        path.addLine(to: CGPoint(x: halfHeight, y: rect.height))
        
        path.addCurve(to: CGPoint(x: 0, y: halfHeight),
                      control1: CGPoint(x: 0, y: rect.height),
                      control2: CGPoint(x: 0, y: halfHeight))
        
        path.addCurve(to: CGPoint(x: halfHeight, y: 0),
                      control1: CGPoint(x: 0, y: 0),
                      control2: CGPoint(x: halfHeight, y: 0))
        
        path.addLine(to: CGPoint(x: halfWidth, y: 0))
        
        return path
    }
}
