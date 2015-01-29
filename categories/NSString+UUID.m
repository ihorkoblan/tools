//
//  NSString+UUID.m
//  ALab
//
//  Created by Volodymyr Shevchyk on 1/24/14.
//  Copyright (c) 2014 Volodymyr Shevchyk. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)
+ (NSString *)uuid {
    CFUUIDRef lUuidRef = CFUUIDCreate(NULL);
    CFStringRef lUuidStringRef = CFUUIDCreateString(NULL, lUuidRef);
    CFRelease(lUuidRef);
    return (__bridge NSString *)(lUuidStringRef);
}
@end
