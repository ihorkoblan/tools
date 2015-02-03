//
//  Security.h
//  Appcident
//
//  Created by Thomas Vervest on 17/12/12.
//  Copyright (c) 2012 squarewolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

#define kEncryptionIVSize kCCBlockSizeAES128

@interface Security : NSObject

+ (NSData *)encryptData:(NSData *)input;
+ (NSData *)encryptData:(NSData *)data theKey:(NSString*)theKey;

+ (NSData *)decryptData:(NSData *)input;
+ (NSData *)decryptData:(NSData *)data theKey:(NSString*)theKey;

+ (NSData*)generateInitVectorWithSize:(size_t)size;
+ (NSData *)AES256EncryptData:(NSData*)data withKey:(NSString *)key andIV:(NSData*)iv;
+ (NSData*)AES256DecryptData:(NSString*)base64Data withKey:(NSString *)key andIV:(NSString*)base64IV;

@end
