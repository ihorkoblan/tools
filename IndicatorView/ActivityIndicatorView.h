//
//  ActivityIndicatorView.h
//  Appcident
//
//  Created by Dominik Ziajka on 11/17/13.
//  Copyright (c) 2013 squarewolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityIndicatorView : UIView {
    UIActivityIndicatorView* _activityIndicator;
    NSString* _image;
    UIView* _backgroundView;
}

- (id) initWithImage: (NSString*) image;

- (void) startAnimating;
- (void) startAnimatingWithIndicator: (BOOL) indicator;
- (void) stopAnimating;
- (void) stopAnimatingAfter: (NSInteger) seconds;

+ (ActivityIndicatorView*) sharedInstance;
+ (ActivityIndicatorView*) sharedInstanceWithImage: (NSString*) image;

@end
