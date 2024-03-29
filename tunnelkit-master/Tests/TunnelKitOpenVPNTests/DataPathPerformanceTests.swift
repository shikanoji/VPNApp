//
//  DataPathPerformanceTests.swift
//  TunnelKitOpenVPNTests
//
//  Created by Davide De Rosa on 7/7/18.
//  Copyright (c) 2022 Davide De Rosa. All rights reserved.
//
//  https://github.com/passepartoutvpn
//
//  This file is part of TunnelKit.
//
//  TunnelKit is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  TunnelKit is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with TunnelKit.  If not, see <http://www.gnu.org/licenses/>.
//
//  This file incorporates work covered by the following copyright and
//  permission notice:
//
//      Copyright (c) 2018-Present Private Internet Access
//
//      Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//      The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import XCTest
@testable import TunnelKitCore
@testable import TunnelKitOpenVPNCore
@testable import TunnelKitOpenVPNProtocol
@testable import TunnelKitOpenVPNAppExtension
import CTunnelKitOpenVPNProtocol

class DataPathPerformanceTests: XCTestCase {
    private var dataPath: DataPath!

    private var encrypter: DataPathEncrypter!

    private var decrypter: DataPathDecrypter!

    override func setUp() {
        let ck = try! SecureRandom.safeData(length: 32)
        let hk = try! SecureRandom.safeData(length: 32)

        let crypto = try! OpenVPN.EncryptionBridge(.aes128cbc, .sha1, ck, ck, hk, hk)
        encrypter = crypto.encrypter()
        decrypter = crypto.decrypter()

        dataPath = DataPath(
            encrypter: encrypter,
            decrypter: decrypter,
            peerId: PacketPeerIdDisabled,
            compressionFraming: .disabled,
            compressionAlgorithm: .disabled,
            maxPackets: 200,
            usesReplayProtection: false
        )
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    // 28ms
//    func testHighLevel() {
//        let packets = TestUtils.generateDataSuite(1200, 1000)
//        var encryptedPackets: [Data]!
//        var decryptedPackets: [Data]!
//        
//        measure {
//            encryptedPackets = try! self.swiftDP.encryptPackets(packets, key: 0)
//            decryptedPackets = try! self.swiftDP.decryptPackets(encryptedPackets, keepAlive: nil)
//        }
//        
    ////        print(">>> \(packets?.count) packets")
//        XCTAssertEqual(decryptedPackets, packets)
//    }

    // 16ms
    func testPointerBased() {
        let packets = TestUtils.generateDataSuite(1200, 1000)
        var encryptedPackets: [Data]!
        var decryptedPackets: [Data]!

        measure {
            encryptedPackets = try! self.dataPath.encryptPackets(packets, key: 0)
            decryptedPackets = try! self.dataPath.decryptPackets(encryptedPackets, keepAlive: nil)
        }

//        print(">>> \(packets?.count) packets")
        XCTAssertEqual(decryptedPackets, packets)
    }
}
