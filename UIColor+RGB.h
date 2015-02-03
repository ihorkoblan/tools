//
//  UIColor+RGB.h
//  Appcident
//
//  Created by Thomas Vervest on 25-06-12.
//  Copyright (c) 2012 squarewolf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    UInt8 b;
    UInt8 g;
    UInt8 r;
    UInt8 a;
} RGBAColor;

typedef struct
{
    UInt8 b;
    UInt8 g;
    UInt8 r;
} RGBColor;

typedef union
{
    RGBAColor raw;
    UInt32 color;
} RGBAConvert;

typedef union
{
    RGBColor raw;
    UInt32 color;
} RGBConvert;

@interface UIColor (RGB)

+ (UIColor*)colorWithRedByte:(UInt8)red greenByte:(UInt8)green blueByte:(UInt8)blue;
+ (UIColor*)colorWithRedByte:(UInt8)red greenByte:(UInt8)green blueByte:(UInt8)blue withAlpha:(UInt8)alpha;
+ (UIColor*)colorWithRGBA:(UInt32)value;
+ (UIColor*)colorWithRGB:(UInt32)value;

@end
