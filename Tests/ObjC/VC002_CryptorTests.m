//
//  VCCryptorTests.m
//  VirgilCypto
//
//  Created by Pavel Gorb on 9/23/15.
//  Copyright (c) 2015 VirgilSecurity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#import "VSCCryptor.h"
#import "VSCKeyPair.h"

@interface VC002_CryptorTests : XCTestCase

@property (nonatomic, strong) NSData* toEncrypt;

@end

@implementation VC002_CryptorTests

@synthesize toEncrypt = _toEncrypt;

- (void)setUp {
    [super setUp];
    
    NSString *message = @"Secret message which is necessary to be encrypted.";
    self.toEncrypt = [message dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
}

- (void)tearDown {
    self.toEncrypt = nil;
    [super tearDown];
}

- (void)test001_createCryptor {
    VSCCryptor *cryptor = [[VSCCryptor alloc] init];
    XCTAssertNotNil(cryptor, @"VSCCryptor instance should be created.");
}

- (void)test002_keyBasedEncryptDecrypt {
    // Encrypt:
    // Generate a new key pair
    VSCKeyPair *keyPair = [[VSCKeyPair alloc] init];
    // Generate a public key id
    NSString *publicKeyId = [NSUUID UUID].UUIDString.lowercaseString;
    NSData *publicKeyIdData= [publicKeyId dataUsingEncoding:NSUTF8StringEncoding];
    // Create a cryptor instance
    VSCCryptor *cryptor = [[VSCCryptor alloc] init];

    XCTAssertFalse([cryptor isKeyRecipientExists:publicKeyIdData], @"It should not contain recipient key after initialization");
    XCTAssertFalse([cryptor isKeyRecipientExists:[NSData data]], @"it should not crash with empty value");

    // Add a key recepient to enable key-based encryption
    NSError *error = nil;
    BOOL success = [cryptor addKeyRecipient:publicKeyIdData publicKey:keyPair.publicKey error:&error];
    if (!success || error != nil) {
        XCTFail(@"Error adding key recipient: %@", [error localizedDescription]);
    }
    XCTAssertTrue([cryptor isKeyRecipientExists:publicKeyIdData], @"It should contain key");

    // Encrypt the data
    error = nil;
    NSTimeInterval ti = [NSDate timeIntervalSinceReferenceDate];
    NSData *encryptedData = [cryptor encryptData:self.toEncrypt embedContentInfo:YES error:&error];
    NSLog(@"Encryption key-based time: %.2f", [NSDate timeIntervalSinceReferenceDate] - ti);
    if (encryptedData.length == 0 || error != nil) {
        XCTFail(@"Error encrypting data: %@", [error localizedDescription]);
    }
    // Decrypt:
    // Create a completely new instance of the VCCryptor object
    VSCCryptor *decryptor = [[VSCCryptor alloc] init];
    // Decrypt data using key-based decryption
    error = nil;
    ti = [NSDate timeIntervalSinceReferenceDate];
    NSData *plainData = [decryptor decryptData:encryptedData recipientId:publicKeyIdData privateKey:keyPair.privateKey keyPassword:nil error:&error];
    NSLog(@"Decryption key-based time: %.2f", [NSDate timeIntervalSinceReferenceDate] - ti);
    if (plainData.length == 0 || error != nil) {
        XCTFail(@"Error decrypting data: %@", [error localizedDescription]);
    }
    XCTAssertEqualObjects(plainData, self.toEncrypt, @"Initial data and decrypted data should be equal.");
}

- (void)test003_passwordBasedEncryptDecrypt {
    // Encrypt:
    NSString *password = @"secret";
    // Create a cryptor instance
    VSCCryptor *cryptor = [[VSCCryptor alloc] init];
    // Add a password recepient to enable password-based encryption
    NSError *error = nil;
    BOOL success = [cryptor addPasswordRecipient:password error:&error];
    if (!success || error != nil) {
        XCTFail(@"Error adding password recipient: %@", [error localizedDescription]);
    }
    // Encrypt the data
    error = nil;
    NSTimeInterval ti = [NSDate timeIntervalSinceReferenceDate];
    NSData *encryptedData = [cryptor encryptData:self.toEncrypt embedContentInfo:NO error:&error];
    NSLog(@"Encryption password-based time: %.2f", [NSDate timeIntervalSinceReferenceDate] - ti);
    if (encryptedData.length == 0 || error != nil) {
        XCTFail(@"Error encrypting data: %@", [error localizedDescription]);
    }
    error = nil;
    NSData *contentInfo = [cryptor contentInfoWithError:&error];
    if (contentInfo.length == 0 || error != nil) {
        XCTFail(@"Error getting content info data: %@", [error localizedDescription]);
    }
    // Decrypt:
    // Create a completely new instance of the VCCryptor object
    VSCCryptor *decryptor = [[VSCCryptor alloc] init];
    // Decrypt data using password-based decryption
    error = nil;
    success = [decryptor setContentInfo:contentInfo error:&error];
    if (!success || error != nil) {
        XCTFail(@"Error setting content info: %@", [error localizedDescription]);
    }
    error = nil;
    ti = [NSDate timeIntervalSinceReferenceDate];
    NSData *plainData = [decryptor decryptData:encryptedData password:password error:&error];
    NSLog(@"Decryption key-based time: %.2f", [NSDate timeIntervalSinceReferenceDate] - ti);
    if (plainData.length == 0 || error != nil) {
        XCTFail(@"Error decryption data: %@", [error localizedDescription]);
    }
    XCTAssertEqualObjects(plainData, self.toEncrypt, @"Initial data and decrypted data should be equal.");
}

@end

