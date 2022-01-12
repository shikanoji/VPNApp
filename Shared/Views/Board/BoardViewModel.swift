//
//  BoardViewModel.swift
//  SysVPN
//
//  Created by Phan Văn Đa on 17/12/2021.
//

import Foundation
import SwiftUI
import RxSwift

class BoardViewModel: ObservableObject {
    
    enum StateBoard {
        case notConnect
        case loading
        case connected
        
        var title: String {
            switch self {
            case .notConnect:
                return LocalizedStringKey.Board.titleNavigationNotConnect.localized
            case .loading:
                return LocalizedStringKey.Board.titleNavigationConnecting.localized
            case .connected:
                return LocalizedStringKey.Board.titleNavigationConnected.localized
            }
        }
        
        var statusTitle: String {
            switch self {
            case .notConnect:
                return LocalizedStringKey.Board.unConnect.localized
            case .loading:
                return LocalizedStringKey.Board.connecting.localized
            case .connected:
                return LocalizedStringKey.Board.connected.localized
            }
        }
        
        var statusColor: Color {
            switch self {
            case .notConnect, .loading:
                return AppColor.VPNUnconnect
            case .connected:
                return AppColor.VPNConnected
            }
        }
        
        var titleButton: String {
            switch self {
            case .notConnect:
                return LocalizedStringKey.Board.unConnect.localized
            case .loading:
                return LocalizedStringKey.Board.connecting.localized
            case .connected:
                return LocalizedStringKey.Board.connected.localized
            }
        }
    }
    
    enum StateTab {
        case location
        case staticIP
        case multiHop
    }
    
    @Published var state: StateBoard = .notConnect
    @Published var ip = "199.199.199.8"
    @Published var nodes: [Node] = []
    @Published var errorMessage: String? = nil
    @Published var tab: StateTab = .location
    @Published var uploadSpeed: CGFloat = 900.1
    @Published var downloadSpeed: CGFloat = 1605
    @Published var showCityNodes: Bool = false
    
    let disposedBag = DisposeBag()
    
    init() {
//        getLocationAvaible()
    }
    
    var x = true
    
    func getLocationAvaible() {
        self.state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            self.x.toggle()
            self.state = self.x ? .notConnect : .connected
//            APIManager.shared.getLocationCity()
//                .subscribe { locations in
//                    self.locations = locations
//                    self.state = .connected
//                } onFailure: { err in
//                    self.errorMessage = err.localizedDescription
//                    self.state = .notConnect
//                }
//                .disposed(by: self.disposedBag)
        }
    }
}
