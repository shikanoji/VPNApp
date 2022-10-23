//
//  LicenseListViewModel.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 21/07/2022.
//

import Foundation

typealias LicensePlistType = [[String: String]]

struct LicenseTitle {
    let filePath: String?
    let title: String?
    
    init(rawData: [String: String]) {
        filePath = rawData["File"]
        title = rawData["Title"]
    }
}

class LicenseListViewModel: ObservableObject {
    var licenseTitlePlists: LicensePlistType?
    @Published var licenseTitleList: [LicenseTitle] = []
    func loadLicenses() {
        guard let plistUrl = Bundle.main.path(forResource: "com.mono0926.LicensePlist", ofType: "plist") else {
            return
        }
        let plistRawDict = NSDictionary(contentsOfFile: plistUrl) as! [String: LicensePlistType]
        var licenseList = plistRawDict["PreferenceSpecifiers"]
        if let index = licenseList?.firstIndex(where: { $0["Title"] == "Licenses" }) {
            licenseList?.remove(at: index)
        }
        licenseTitlePlists = licenseList
        guard let licenseTitlePlists = licenseTitlePlists else {
            return
        }
        var list: [LicenseTitle] = []
        licenseTitlePlists.forEach({ list.append(LicenseTitle(rawData: $0)) })
        licenseTitleList = list
    }
}
