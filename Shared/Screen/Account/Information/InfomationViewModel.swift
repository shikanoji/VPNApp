//
//  InfomationViewModel.swift
//  SysVPN
//
//  Created by Da Phan Van on 11/06/2022.
//

import Foundation

class InfomationViewModel: ObservableObject {
    @Published var section: SectionCell = .init(.infomation)
    @Published var showDeleteAccountPhone = false
    @Published var showDeleteAccountPad = false
    @Published var showChangePasswordPhone = false
    @Published var showChangePasswordPad = false

    @Published var showAlert: Bool = false
    var alertMessage: String = ""

    init() {
    }
}
