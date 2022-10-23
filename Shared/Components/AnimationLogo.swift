//
//  AnimationLogo.swift
//  SysVPN
//
//  Created by Định Nguyễn on 26/08/2022.
//

import SwiftUI

struct AnimationLogo: View {
    
    @State private var color = Color("ColorLogo")
    @State private var gradient = [Color.clear, Color.clear, Color.clear, Color.clear, Color.clear, Color.clear, Color("ColorLogo").opacity(0.5), Color("ColorLogo").opacity(0.8), Color("ColorLogo")]
    @State private var gradient1 = [Color.red]
    @State private var onModel = 0.0
    @State private var paddingImage = 8.0
    @State private var sizeBoder = 8
    @State private var speedAnimation = 2.0
    
    var body: some View {
        ZStack {
            Asset.Assets.launchScreenBackGround.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack {
                Asset.Assets.logoLarge.swiftUIImage
                    .padding(paddingImage)
                    .overlay(CustomBackLogo(startAngle: .degrees(360), engAngle: .degrees(180), clockwise: true)
                        .stroke(
                            AngularGradient(colors: gradient, center: .center, angle: .degrees(-onModel)),
                            style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                        )
                        .foregroundColor(.green)
                        .onAppear() {
                            withAnimation(Animation.linear(duration: speedAnimation).repeatForever(autoreverses: false)) {
                                onModel -= 360
                            }
                        }
                    )
                    .padding(.bottom, 30)
                
                Asset.Assets.logoText.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 70, alignment: .center)
                    .padding(.top, 2)
            }
        }
    }
}

struct CustomBackLogo: Shape {
    
    let startAngle: Angle
    let engAngle: Angle
    let clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX - 10, y: rect.midY/30))
                
        // Left
        let rotationAdjustmentLeft = Angle.degrees(125)
        let modifiedStartLeft = Angle.degrees(10) - rotationAdjustmentLeft
        let modifiedEndLeft = Angle.degrees(300) - rotationAdjustmentLeft
        // vertical degree left and horizontal degree left set coordinates circle bounded left logo
        let horizontalDegreeLeft = 15.0
        let verticalDegreeLeft = 3.0
        path.addArc(center: CGPoint(x: rect.minX + horizontalDegreeLeft, y: rect.maxY/4 + verticalDegreeLeft), radius: rect.width/10, startAngle: modifiedStartLeft, endAngle: modifiedEndLeft, clockwise: clockwise)
        
        // Bottom
        let rotationAdjustmentBottom = Angle.degrees(180)
        let modifiedStartBottom = startAngle - rotationAdjustmentBottom
        let modifiedEndBottom = engAngle - rotationAdjustmentBottom
        // vertical degree bottom set coordinates circle bounded left logo
        let verticalDegreeBottom = 1.79
        path.addArc(center: CGPoint(x: rect.maxX/2, y: rect.maxY/verticalDegreeBottom), radius: rect.width/2, startAngle: modifiedStartBottom, endAngle: modifiedEndBottom, clockwise: clockwise)
        
        // Right
        let rotationAdjustmentRight = Angle.degrees(0)
        let modifiedStartRight = Angle.degrees(0) - rotationAdjustmentRight
        let modifiedEndRight = Angle.degrees(300) - rotationAdjustmentRight
        // vertical degree right and horizontal degree right set coordinates circle bounded left logo
        let verticalDegreeRight = 3.8
        let horizontalDegreeRight = 15.0
        path.addArc(center: CGPoint(x: rect.maxX - horizontalDegreeRight, y: rect.maxY/verticalDegreeRight), radius: rect.width/10, startAngle: modifiedStartRight, endAngle: modifiedEndRight, clockwise: clockwise)
        
        // Top
        let rotationAdjustmentTop = Angle.degrees(60)
        let modifiedStartTop = Angle.degrees(0) - rotationAdjustmentTop
        let modifiedEndTop = Angle.degrees(320) - rotationAdjustmentTop
        // vertical degree top set coordinates circle bounded top up logo
        let verticalDegreeTop = 5.8
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY/verticalDegreeTop), radius: rect.width/10, startAngle: modifiedStartTop, endAngle: modifiedEndTop, clockwise: clockwise)
        
        path.closeSubpath()
        return path
    }
}

struct AnimationLogo_Previews: PreviewProvider {
    static var previews: some View {
        AnimationLogo()
    }
}
