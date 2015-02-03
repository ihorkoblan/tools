
#include "UIImage+Effects.h"

@implementation UIImage (UIImageEffects)
    
- (UIImage*) createGrayCopy {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    int width = CGImageGetWidth(self.CGImage);
    int height = CGImageGetHeight(self.CGImage);
    
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  CGImageGetBytesPerRow(self.CGImage),
                                                  colorSpace,
                                                  kCGImageAlphaNone);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,
                       CGRectMake(0,
                                  0,
                                  width,
                                  height),
                       self.CGImage);
    
    CGFloat scale = 1.0f;
    if ([UIScreen instancesRespondToSelector:@selector(scale)])
    {
        scale = [[UIScreen mainScreen] scale];
    }
    
    CGImageRef img = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:img
                                             scale:scale
                                       orientation:UIImageOrientationUp];
    CGImageRelease(img);
    CGContextRelease(context);
    
    return grayImage;
}

@end