//
//  VirgilCryptoSwiftTests.swift
//  VirgilCryptoSwiftTests
//
//  Created by Pavel Gorb on 9/23/15.
//  Copyright (c) 2015 VirgilSecurity. All rights reserved.
//

import UIKit
import XCTest

class VC003_SignerSwiftTests: XCTestCase {
    
    var toSign: NSData! = nil
    
    override func setUp() {
        super.setUp()
        
        let message = NSString(string: "Message which is need to be signed.")
        self.toSign = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:false)
    }
    
    override func tearDown() {
        self.toSign = nil
        super.tearDown()
    }
    
    func test001_createSigner() {
        let signer = VSSSigner()
        XCTAssertNotNil(signer, "VCSigner instance should be created.");
    }
    
    func test002_composeAndVerifySignature() {
        // Generate a new key pair
        let keyPair = VSSKeyPair()
    
        // Compose signature:
        // Create the signer
        let signer = VSSSigner()
        // Compose the signature
        if let signature = signer.signData(self.toSign, privateKey: keyPair.privateKey(), keyPassword: nil) {
            XCTAssertTrue(signature.length > 0, "Signature should have an actual content.");
            
            // Verify signature:
            // Create a verifier
            let verifier = VSSSigner()
            let trusted = verifier.verifySignature(signature, data: self.toSign, publicKey: keyPair.publicKey())
            XCTAssertTrue(trusted, "Signature should be correct and verified.");
        }
        else {
            XCTFail("Signature should be composed properly.")
        }
    }
    
}