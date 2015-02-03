//
//  UIImage+Merge.h
//  Appcident
//
//  Created by Admin on 07.11.14.
//  Copyright (c) 2014 squarewolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Merge)

/* \brief Category class method for merging two images into one
 *
 */
+ (UIImage *)mergeImage:(UIImage *)imageFirst
              withImage:(UIImage *)imageSecond;

@end
