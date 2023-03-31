//
//  RootSceneTests.swift
//  iOSAppTests
//
//  Created by Morisson Marcel on 01/12/22.
//

@testable import BasicApp
import SnapshotTesting
import ViewInspector
import XCTest
import SwiftUI
import UIKit

final class RootSceneTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        SnapshotTesting.isRecording = false
    }
    
    var snapshotDirectory: String {
        return #filePath.replacingOccurrences(of: "Sources/RootSceneTests.swift", with: "ReferenceImages")
    }
    
    func testViewHierarchy() throws {
        let sut = RootScene()
        let value = try? sut.inspect().find(text: "Hello, World!")
        XCTAssertNotNil(value)
    }
    
    func testRootSceneSnapshot() {
        let sut = RootScene()
        let vc = UIHostingController(rootView: sut)

        let error = verifySnapshot(matching: vc, as: .image(on: .iPhone8), snapshotDirectory: self.snapshotDirectory)
        XCTAssertNil(error)
    }
}
