//
//  VC005_ChunkCryptorTests.m
//  VirgilCypto
//
//  Created by Pavel Gorb on 3/3/16.
//  Copyright © 2016 VirgilSecurity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#import "VSCChunkCryptor.h"
#import "VSCKeyPair.h"

static const NSUInteger kPlainDataLength = 5120;
static const NSUInteger kDesiredDataChunkLength = 1024;

@interface VC005_ChunkCryptorTests : XCTestCase

@property (nonatomic, strong) NSData* toEncrypt;

- (NSData * __nonnull)randomDataWithBytes:(NSUInteger)length;

@end

@implementation VC005_ChunkCryptorTests

@synthesize toEncrypt = _toEncrypt;

- (void)setUp {
    [super setUp];
    
    self.toEncrypt = [self randomDataWithBytes:kPlainDataLength];
}

- (void)tearDown {
    self.toEncrypt = nil;
    
    [super tearDown];
}

- (void)test001_createStreamCryptor {
    VSCChunkCryptor *cryptor = [[VSCChunkCryptor alloc] init];
    XCTAssertNotNil(cryptor, @"VSCChunkCryptor instance should be created.");
}

- (void)test002_keyBasedEncryptDecrypt {
    // Encrypt:
    // Generate a new key pair
    NSError *error = nil;
    VSCKeyPair *keyPair = [[VSCKeyPair alloc] init];
    // Generate a recepient id
    NSString *recipientId = [NSUUID UUID].UUIDString.lowercaseString;
    NSData *recipientIdData = [recipientId dataUsingEncoding:NSUTF8StringEncoding];
    // Create a cryptor instance
    VSCChunkCryptor *cryptor = [[VSCChunkCryptor alloc] init];
    // Add a key recepient to enable key-based encryption
    [cryptor addKeyRecipient:recipientIdData publicKey:keyPair.publicKey error:&error];
    if (error != nil) {
        NSLog(@"Add key recipient error: %@", error.localizedDescription);
        XCTAssertTrue(FALSE);
    }
    // Encrypt the data
    NSInputStream *istream = [NSInputStream inputStreamWithData:self.toEncrypt];
    NSOutputStream *ostream = [NSOutputStream outputStreamToMemory];

    NSTimeInterval ti = [NSDate timeIntervalSinceReferenceDate];
    [cryptor encryptDataFromStream:istream toStream:ostream preferredChunkSize:kDesiredDataChunkLength embedContentInfo:YES error:&error];
    NSLog(@"Encryption key-based time: %.2f", [NSDate timeIntervalSinceReferenceDate] - ti);
    if (error != nil) {
        NSLog(@"Encryption error: %@", error.localizedDescription);
        XCTAssertTrue(FALSE);
    }
    NSData *encryptedData = (NSData *)[ostream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    XCTAssertTrue(encryptedData.length > 0, @"Cryptor should encrypt the given input stream data using key-based encryption.");

    // Decrypt:
    // Create a completely new instance of the VCCryptor object
    VSCChunkCryptor *decryptor = [[VSCChunkCryptor alloc] init];
    NSInputStream *idecstream = [NSInputStream inputStreamWithData:encryptedData];
    NSOutputStream *odecsctream = [NSOutputStream outputStreamToMemory];

    // Decrypt data using key-based decryption
    error = nil;
    ti = [NSDate timeIntervalSinceReferenceDate];
    [decryptor decryptFromStream:idecstream toStream:odecsctream recipientId:recipientIdData privateKey:keyPair.privateKey keyPassword:nil error:&error];
    NSLog(@"Decryption key-based time: %.2f", [NSDate timeIntervalSinceReferenceDate] - ti);
    if (error != nil) {
        NSLog(@"Decryption error: %@", error.localizedDescription);
        XCTAssertTrue(FALSE);
    }
    NSData *plainData = (NSData *)[odecsctream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    XCTAssertEqualObjects(plainData, self.toEncrypt, @"Initial data and decrypted data should be equal.");
}

- (void)test003_passwordBasedEncryptDecrypt {
    // Encrypt:
    NSError *error = nil;
    NSString *password = @"secret";
    // Create a cryptor instance
    VSCChunkCryptor *cryptor = [[VSCChunkCryptor alloc] init];
    // Add a password recepient to enable password-based encryption
    [cryptor addPasswordRecipient:password error:&error];
    if (error != nil) {
        NSLog(@"Add password recipient error: %@", error.localizedDescription);
        XCTAssertTrue(FALSE);
    }
    
    NSInputStream *istream = [NSInputStream inputStreamWithData:self.toEncrypt];
    NSOutputStream *ostream = [NSOutputStream outputStreamToMemory];
    // Encrypt the data
    NSTimeInterval ti = [NSDate timeIntervalSinceReferenceDate];
    [cryptor encryptDataFromStream:istream toStream:ostream preferredChunkSize:kDesiredDataChunkLength embedContentInfo:NO error:&error];
    NSLog(@"Encryption password-based time: %.2f", [NSDate timeIntervalSinceReferenceDate] - ti);
    if (error != nil) {
        NSLog(@"Encryption error: %@", error.localizedDescription);
        XCTAssertTrue(FALSE);
    }
    NSData *encryptedData = (NSData *)[ostream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    NSData *contentInfo = [cryptor contentInfoWithError:nil];
    if (contentInfo == nil) {
        NSLog(@"There is no content info after encryption.");
        XCTAssertTrue(FALSE);
    }
    XCTAssertTrue(encryptedData.length > 0, @"Cryptor should encrypt the given plain data using password-based encryption.");
    
    // Decrypt:
    // Create a completely new instance of the VCCryptor object
    VSCChunkCryptor *decryptor = [[VSCChunkCryptor alloc] init];
    error = nil;
    [decryptor setContentInfo:contentInfo error:&error];
    if (error != nil) {
        NSLog(@"Error setting content info: %@", error.localizedDescription);
        XCTAssertTrue(FALSE);
    }
    NSInputStream *idecstream = [NSInputStream inputStreamWithData:encryptedData];
    NSOutputStream *odecsctream = [NSOutputStream outputStreamToMemory];
    error = nil;
    // Decrypt data using password-based decryption
    ti = [NSDate timeIntervalSinceReferenceDate];
    [decryptor decryptFromStream:idecstream toStream:odecsctream password:password error:&error];
    NSLog(@"Decryption password-based time: %.2f", [NSDate timeIntervalSinceReferenceDate] - ti);
    if (error != nil) {
        NSLog(@"Decryption error: %@", error.localizedDescription);
        XCTAssertTrue(FALSE);
    }
    NSData *plainData = (NSData *)[odecsctream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    XCTAssertEqualObjects(plainData, self.toEncrypt, @"Initial data and decrypted data should be equal.");
}

- (NSData *)randomDataWithBytes:(NSUInteger)length {
    NSMutableData *mutableData = [NSMutableData dataWithCapacity:length];
    for (unsigned int i = 0; i < length; i++) {
        NSInteger randomBits = arc4random();
        [mutableData appendBytes:(void *)&randomBits length:1];
    }
    return mutableData;
}


@end
