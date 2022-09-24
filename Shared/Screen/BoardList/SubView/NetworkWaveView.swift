//
//  NetworkWaveView.swift
//  SysVPN
//
//  Created by Da Phan Van on 19/01/2022.
//

import SwiftUI

struct NetworkWaveView: View {
    
    @State var lineNumber = AppSetting.shared.lineNetwork
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 2.64) {
            RoundedRectangle(cornerRadius: 1)
                .fill(lineNumber >= 1 ? AppColor.VPNConnected : AppColor.whiteStatus)
                .frame(width: 3.96, height: 3.6)
            RoundedRectangle(cornerRadius: 1)
                .fill(lineNumber >= 2 ? AppColor.VPNConnected : AppColor.whiteStatus)
                .frame(width: 3.96, height: 4.8)
            RoundedRectangle(cornerRadius: 1)
                .fill(lineNumber >= 3 ? AppColor.VPNConnected : AppColor.whiteStatus)
                .frame(width: 3.96, height: 7.2)
            RoundedRectangle(cornerRadius: 1)
                .fill(lineNumber >= 4 ? AppColor.VPNConnected : AppColor.whiteStatus)
                .frame(width: 3.96, height: 9.6)
            RoundedRectangle(cornerRadius: 1)
                .fill(lineNumber >= 5 ? AppColor.VPNConnected : AppColor.whiteStatus)
                .frame(width: 3.96, height: 12)
        }
        .frame(width: 30.48, height: 12)
        .onAppear {
            lineNumber = AppSetting.shared.lineNetwork
        }
    }
}

struct NetworkWaveView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkWaveView(lineNumber: 3)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 40, height: 20))
    }
}
