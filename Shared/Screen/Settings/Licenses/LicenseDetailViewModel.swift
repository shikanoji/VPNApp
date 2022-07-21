//
//  LicenseDetailViewModel.swift
//  SysVPN
//
//  Created by Nguyen Dinh Thach on 21/07/2022.
//

import Foundation

class LicenseDetailViewModel: ObservableObject {
    var license: LicenseTitle
    @Published var licenseText: String = ""
    init(license: LicenseTitle) {
        self.license = license
    }
    func loadLicenseDetail() {
        guard let plistUrl = Bundle.main.path(forResource: license.filePath, ofType: "plist"),
                      let plistRawDict = NSDictionary(contentsOfFile: plistUrl) as? [String: LicensePlistType],
                      let licenseBodyPlistArray = plistRawDict["PreferenceSpecifiers"],
                      let licenseBodyPlist = licenseBodyPlistArray.first else {
                    return
                }
        licenseText = licenseBodyPlist["FooterText"] ?? ""
    }
}
