//
//  SysVPN
//
//  Created by Da Phan Van on 17/01/2022.
//

import SwiftUI

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

enum PositionItemCell {
    case top
    case middle
    case bot
    case all
    
    var rectCorner: UIRectCorner {
        switch self {
        case .top:
            return [.topLeft, .topRight]
        case .middle:
            return []
        case .bot:
            return [.bottomLeft, .bottomRight]
        case .all:
            return [.allCorners]
        }
    }
}

struct ItemRowCell: View {
    @State var title: String = ""
    @State var content: String = ""
    @State var showRightButton = false
    @State var showSwitch = false
    @State var showSelect = false
    @State var alertContent = ""
    
    @State var position: PositionItemCell = .middle
    var item: ItemCell? = nil
    var switchValue: Bool = false
    var onSwitchValueChange: ((Bool) -> Void)?
    
    var body: some View {
        HStack {
            Spacer().frame(width: 16)
            if item?.type == .fastestServer {
                if let autoConnectNode = AppSetting.shared.getAutoConnectNode(),
                   let flag = autoConnectNode.flag {
                    ImageView(withURL: flag, size: Constant.BoardList.heightImageNode)
                        .clipShape(Circle())
                } else {
                    Asset.Assets.fastestServerIcon.swiftUIImage
                }
                Spacer().frame(width: 16)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(Constant.Menu.fontItem)
                    .foregroundColor(.white)
                if content != "" {
                    Text(content)
                        .font(Constant.Menu.fontSubItem)
                        .foregroundColor(AppColor.lightBlackText)
                }
                if alertContent != "" {
                    Text(alertContent)
                        .font(Constant.Menu.fontSubItem)
                        .foregroundColor(AppColor.VPNUnconnect)
                }
            }
            Spacer()
            Group {
                if showRightButton {
                    Image(Constant.Account.rightButton)
                        .padding()
                } else if showSwitch {
                    Toggle(isOn: Binding<Bool>(
                        get: { switchValue },
                        set: { value in
                            if let action = onSwitchValueChange {
                                action(value)
                            }
                        }
                    )) {}
                        .toggleStyle(CheckmarkToggleStyle())
                } else if showSelect {
                    Toggle(isOn: Binding<Bool>(
                        get: { switchValue },
                        set: { value in
                            if let action = onSwitchValueChange {
                                action(value)
                            }
                        }
                    )) {}
                        .toggleStyle(SelectToggleStyle())
                }
            }
            .frame(width: 50)
            Spacer().frame(width: 15)
        }
        .padding(.vertical, 8.0)
        .frame(minHeight: Constant.Menu.heightItemMenu)
        .frame(maxWidth: .infinity)
        .background(AppColor.darkButton)
        .cornerRadius(radius: Constant.Menu.radiusCell, corners: [position.rectCorner])
    }
}

struct SettingRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowCell(title: "Your email", content: "", showRightButton: false, showSwitch: false, showSelect: true, switchValue: true)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/343.0/*@END_MENU_TOKEN@*/, height: Constant.Menu.heightItemCell + 200))
    }
}

struct CheckmarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack {
                Rectangle()
                    .foregroundColor(AppColor.backgroundStatusView)
                    .frame(width: 38, height: 23, alignment: .center)
                    .cornerRadius(20)
                    .onTapGesture { configuration.isOn.toggle() }
                Circle()
                    .padding(.all, 3)
                    .foregroundColor(configuration.isOn ? AppColor.VPNConnected : .gray)
                    .frame(width: 30, height: 30)
                    .offset(x: configuration.isOn ? 11 : -11, y: 0)
                    .animation(Animation.linear(duration: 0.1))
            }
        }
    }
}

struct SelectToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack {
                if configuration.isOn {
                    Constant.Global.iconCheck
                        .frame(width: 30, height: 30)
                } else {
                    Constant.Global.iconUncheck
                        .frame(width: 30, height: 30)
                }
            }.onTapGesture { configuration.isOn.toggle() }
        }
    }
}
