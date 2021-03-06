//
//  VSCPfsSessionPrivate.h
//  VirgilCrypto
//
//  Created by Oleksandr Deundiak on 6/14/17.
//  Copyright © 2017 VirgilSecurity. All rights reserved.
//

#import "VSCPfsSession.h"

#import <virgil/crypto/pfs/VirgilPFSSession.h>

using virgil::crypto::pfs::VirgilPFSSession;

@interface VSCPfsSession ()

- (instancetype __nullable)initWithSession:(const VirgilPFSSession &)session;

@property (nonatomic, assign, readonly) VirgilPFSSession * __nonnull cppPfsSession;

@end
