Pod::Spec.new do |s|
  s.name                        = "VirgilCrypto"
  s.version                     = "2.0.0-beta5"
  s.summary                     = "Contains basic classes for creating key pairs, encrypting/decrypting data, signing data and verifying signs."
  s.homepage                    = "https://github.com/VirgilSecurity/virgil-foundation-x"
  s.cocoapods_version           = ">= 0.36"
  s.license                     = { :type => "BSD", :file => "LICENSE" }
  s.author                      = { "Yaroslav T" => "yaros8t@gmail.com" }
  s.platforms                   = { :ios => "7.0" }
  s.source                      = { :git => "https://github.com/VirgilSecurity/virgil-foundation-x.git", :tag => s.version }
  s.module_name                 = "VirgilCrypto"
  s.source_files                = "Wrapper/*"
  s.public_header_files         = "Wrapper/*.h"
  s.private_header_files        = "Wrapper/*Private.h"
  s.requires_arc                = true
  s.library                     = "stdc++"
  # s.osx.vendored_frameworks     = "Frameworks/osx/*.framework"
  s.ios.vendored_frameworks     = "Frameworks/ios/*.framework"
  # s.watchos.vendored_frameworks = "Frameworks/watchos/*.framework"
  # s.tvos.vendored_frameworks    = "Frameworks/tvos/*.framework"
  s.xcconfig                    = { "HEADER_SEARCH_PATHS" => "$(FRAMEWORK_SEARCH_PATHS)/VirgilCrypto.framework/Headers" }
end