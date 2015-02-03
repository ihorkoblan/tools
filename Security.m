//
//  Security.m
//  Appcident
//
//  Created by Thomas Vervest on 17/12/12.
//  Copyright (c) 2012 squarewolf. All rights reserved.
//

#import "Security.h"
#import "NSData+Base64.h"
#import "Base64.h"

@implementation Security

/*
 ** This code was added to support encryption of the DB.
 ** The password is stored in the keychain, if one doesn't exist a random
 ** string is generated and used as the password
 */

+ (NSString *)generateKey
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:256];
    for (NSUInteger i = 0U; i < 256; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

+ (NSData *)randomDataOfLength:(size_t)length {
    NSMutableData *data = [NSMutableData dataWithLength:length];
	
#ifdef DEBUG
    int result = SecRandomCopyBytes(kSecRandomDefault, length, data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d", errno);
#endif
    return data;
}

// Parts taken from https://github.com/rnapier/RNCryptor
+ (NSData *)encryptData:(NSData *)data
{
#ifdef USE_ENCRYPTION
    return [self encryptData:data theKey:[self encryptionKey]];
#else
	return data;
#endif
}

+ (NSData *)encryptData:(NSData *)data theKey:(NSString*)theKey
{
    NSData *key = [theKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData *iv = [self randomDataOfLength:kEncryptionIVSize];
	
    size_t outLength;
    NSMutableData *cipherData = [NSMutableData dataWithLength:data.length + kCCBlockSizeAES128];
	
    CCCryptorStatus
    result = CCCrypt(kCCEncrypt, // operation
                     kCCAlgorithmAES128, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     key.bytes, // key
                     kCCKeySizeAES256, // keylength
                     iv.bytes,// iv
                     data.bytes, // dataIn
                     data.length, // dataInLength,
                     cipherData.mutableBytes, // dataOut
                     cipherData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
	
    if (result == kCCSuccess) {
        cipherData.length = outLength;
    } else {
        return nil;
    }
	
	// The IV is always the first 16 bytes of the file
	NSMutableData *completeData = [NSMutableData data];
	[completeData appendData:iv];
	[completeData appendData:cipherData];
    
    return completeData;
}

// Parts taken from https://github.com/rnapier/RNCryptor
+ (NSData *)decryptData:(NSData *)data
{
#ifdef USE_ENCRYPTION
	return [self decryptData:data theKey:[self encryptionKey]];
#else
	return data;
#endif
}

+ (NSData *)decryptData:(NSData *)data theKey:(NSString*)theKey
{
    NSData *key = [theKey dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data.length <= kEncryptionIVSize) {
		return nil;
	}
	
	// First tease out the IV from the start of the data
	NSData *iv = [data subdataWithRange:NSMakeRange(0, kEncryptionIVSize)];
	NSData *cipherData = [data subdataWithRange:NSMakeRange(kEncryptionIVSize, data.length - kEncryptionIVSize)];
    
    size_t outLength;
    NSMutableData *decryptedData = [NSMutableData dataWithLength:data.length];
    CCCryptorStatus
    result = CCCrypt(kCCDecrypt, // operation
                     kCCAlgorithmAES128, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     key.bytes, // key
                     kCCKeySizeAES256, // keylength
                     iv.bytes,// iv
                     cipherData.bytes, // dataIn
                     cipherData.length, // dataInLength,
                     decryptedData.mutableBytes, // dataOut
                     decryptedData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        [decryptedData setLength:outLength];
    } else {
        return nil;
    }
    
    return decryptedData;
}

+ (NSData*)generateInitVectorWithSize:(size_t)size
{
    uint8_t *bytes = malloc(size);
    arc4random_buf(bytes, size);
    return [NSData dataWithBytesNoCopy:bytes length:size];
}

+ (NSData *)AES256EncryptData:(NSData*)data withKey:(NSString *)key andIV:(NSData*)iv
{
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSASCIIStringEncoding];
	   
	NSUInteger dataLength = [data length];
	
	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesEncrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          [key cStringUsingEncoding:NSUTF8StringEncoding], kCCKeySizeAES256,
                                          iv.bytes, /* initialization vector (optional) */
                                          data.bytes, dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
	}
    
	free(buffer); //free the buffer;
	return nil;
}

+ (NSData*)AES256DecryptData:(NSString*)base64Data withKey:(NSString *)key andIV:(NSString*)base64IV {
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
    // fetch key data
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSASCIIStringEncoding];
    
    NSData* iv = [Base64 base64DecodeString:base64IV];
    NSData* data = [Base64 base64DecodeString:base64Data];
    
    NSUInteger dataLength = [data length];
    
	//See the doc: For block ciphers, the output size will always be less than or
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength*2;// + kCCKeySizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesDecrypted = 0;
    
    int mode = kCCOptionPKCS7Padding;
    
    
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, mode,
                                          [key dataUsingEncoding:NSASCIIStringEncoding].bytes, kCCKeySizeAES256,
                                          iv.bytes /* initialization vector (optional) */,
                                          data.bytes, dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
	
	if (cryptStatus == kCCSuccess) {
        
		//the returned NSData takes ownership of the buffer and will free it on deallocation
        int i=0;
        for (; i<numBytesDecrypted; i++)
        {
            if (((char*)buffer)[dataLength-(i+1)] != 0)
            {
                break;
            }
            
        }
		return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
	}else{
        NSLog(@"%i", cryptStatus);
    }
	
	free(buffer); //free the buffer;
	return nil;
}

@end
