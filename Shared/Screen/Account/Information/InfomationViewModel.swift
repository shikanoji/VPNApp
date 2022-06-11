//
//  InfomationViewModel.swift
//  SysVPN
//
//  Created by Da Phan Van on 11/06/2022.
//

import Foundation

class InfomationViewModel: ObservableObject {
    @Published var section: SectionCell = .init(.infomation)
    
    init() {
    }
}
