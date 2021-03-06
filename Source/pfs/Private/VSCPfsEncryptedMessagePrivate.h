//
//  VSCPfsEncryptedMessagePrivate.h
//  VirgilCrypto
//
//  Created by Oleksandr Deundiak on 6/14/17.
//  Copyright © 2017 VirgilSecurity. All rights reserved.
//

#import "VSCPfsEncryptedMessage.h"

#import <virgil/crypto/pfs/VirgilPFSEncryptedMessage.h>

using virgil::crypto::pfs::VirgilPFSEncryptedMessage;

@interface VSCPfsEncryptedMessage ()

- (instancetype __nullable)initWithEncryptedMessage:(const VirgilPFSEncryptedMessage &)encryptedMessage;

@property (nonatomic, assign, readonly) VirgilPFSEncryptedMessage * __nonnull cppPfsEncryptedMessage;

@end
