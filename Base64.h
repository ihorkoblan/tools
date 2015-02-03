//
//  Base64.h
//  Appcident
//
//  Created by Thomas Vervest on 17/12/12.
//  Copyright (c) 2012 squarewolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject

+ (NSString *) base64EncodeString: (NSString *) strData;
+ (NSString *) base64EncodeData: (NSData *) objData;
+ (NSData *) base64DecodeString: (NSString *) strBase64;

@end
