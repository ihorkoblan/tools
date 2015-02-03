//
//  NSString+Occurrences.m
//  Appcident
//
//  Created by Thomas Vervest on 25-06-12.
//  Copyright (c) 2012 squarewolf. All rights reserved.
//

#include "NSString+Occurrences.h"

@implementation NSString (Occurrences)

- (NSUInteger)occurrencesOfString:(NSString *)string
{
    NSUInteger count = 0;
    NSUInteger length = self.length;
    NSRange range = NSMakeRange(0, length); 
    
    while(range.location != NSNotFound)
    {
        range = [self rangeOfString:string
                            options:0
                              range:range];
        
        if (range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++; 
        }
    }
    
    return count;
}

@end