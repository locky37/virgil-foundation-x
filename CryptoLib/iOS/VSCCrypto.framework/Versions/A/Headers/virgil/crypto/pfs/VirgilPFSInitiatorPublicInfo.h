/**
 * Copyright (C) 2015-2017 Virgil Security Inc.
 *
 * Lead Maintainer: Virgil Security Inc. <support@virgilsecurity.com>
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     (1) Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *     (2) Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *     (3) Neither the name of the copyright holder nor the names of its
 *     contributors may be used to endorse or promote products derived from
 *     this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ''AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef VIRGIL_CRYPTO_PFS_VIRGIL_PFS_INITIATOR_PUBLIC_INFO_H
#define VIRGIL_CRYPTO_PFS_VIRGIL_PFS_INITIATOR_PUBLIC_INFO_H

#include <virgil/crypto/VirgilByteArray.h>
#include <virgil/crypto/pfs/VirgilPFSPublicKey.h>

namespace virgil { namespace crypto { namespace pfs {

/**
 * @brief This is model object that represent public information of a PFS Initiator.
 *
 * Initiator ia a side that starts communication.
 *
 * @see VirgilPFS
 * @ingroup pfs
 */
class VirgilPFSInitiatorPublicInfo {
public:
    /**
     * @param identifier - Initiator unique identifier.
     * @param identityPublicKey - public key that is connected to the Initiator's identity.
     * @param ephemeralPublicKey - ephemeral public key.
     */
    VirgilPFSInitiatorPublicInfo(
            std::string identifier, VirgilPFSPublicKey identityPublicKey, VirgilPFSPublicKey ephemeralPublicKey);

    /**
     * @brief Getter.
     * @see VirgilPFSInitiatorPublicInfo()
     */
    const std::string& getIdentifier() const;

    /**
     * @brief Getter.
     * @see VirgilPFSInitiatorPublicInfo()
     */
    const VirgilPFSPublicKey& getIdentityPublicKey() const;

    /**
     * @brief Getter.
     * @see VirgilPFSInitiatorPublicInfo()
     */
    const VirgilPFSPublicKey& getEphemeralPublicKey() const;

private:
    std::string identifier_;
    VirgilPFSPublicKey identityPublicKey_;
    VirgilPFSPublicKey ephemeralPublicKey_;
};

}}}

#endif //VIRGIL_CRYPTO_PFS_VIRGIL_PFS_INITIATOR_PUBLIC_INFO_H
