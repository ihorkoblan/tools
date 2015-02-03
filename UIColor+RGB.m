//
//  UIColor+RGB.m
//  Appcident
//
//  Created by Thomas Vervest on 25-06-12.
//  Copyright (c) 2012 squarewolf. All rights reserved.
//

#include "UIColor+RGB.h"

@implementation UIColor (RGB)

+ (UIColor*)colorWithRedByte:(UInt8)red greenByte:(UInt8)green blueByte:(UInt8)blue
{
    return [UIColor colorWithRedByte:red
                           greenByte:green
                            blueByte:blue
                           withAlpha:255];
}

+ (UIColor*)colorWithRedByte:(UInt8)red greenByte:(UInt8)green blueByte:(UInt8)blue withAlpha:(UInt8)alpha
{
    return [UIColor colorWithRed:red / 255.0f
                           green:green / 255.0f
                            blue:blue / 255.0f
                           alpha:alpha / 255.0f];
}

+ (UIColor*)colorWithRGBA:(UInt32)value
{
    RGBAConvert convert;
    convert.color = value;
    return [UIColor colorWithRedByte:convert.raw.r
                           greenByte:convert.raw.g
                            blueByte:convert.raw.b
                           withAlpha:convert.raw.a];
}

+ (UIColor*)colorWithRGB:(UInt32)value;
{
    RGBConvert convert;
    convert.color = value;
    return [UIColor colorWithRedByte:convert.raw.r
                           greenByte:convert.raw.g
                            blueByte:convert.raw.b
                           withAlpha:255];
}

@end