//
//  NSString+UUID.m
//  Appcident
//
//  Created by Alex on 6/10/14.
//  Copyright (c) 2014 squarewolf. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)


+ (NSString *)uuidString{
    // Returns a UUID
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidString;
}

@end
