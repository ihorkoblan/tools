//
//  UIImage+Merge.m
//  Appcident
//
//  Created by Admin on 07.11.14.
//  Copyright (c) 2014 squarewolf. All rights reserved.
//

#import "UIImage+Merge.h"

@implementation UIImage(Merge)

+ (UIImage *)mergeImage:(UIImage *)imageFirst
              withImage:(UIImage *)imageSecond
{
    UIGraphicsBeginImageContext(imageFirst.size);
    
    [imageFirst drawAtPoint:CGPointZero];
    float offsetX = fabs(imageFirst.size.width - imageSecond.size.width) / 2.0f;
    float offsetY = fabs(imageFirst.size.height - imageSecond.size.height) / 2.0f;
    [imageSecond drawAtPoint:CGPointMake(offsetX, offsetY)];
    
    UIImage *mergedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return mergedImage;
}

@end
