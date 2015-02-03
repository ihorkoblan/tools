//
//  BlackActivityIndicatorView.h
//  Appcident
//
//  Created by fuzza on 01.04.14.
//  Copyright (c) 2014 squarewolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlackActivityIndicatorView : UIView

+ (instancetype) sharedInstance;

- (void) startAnimating;
- (void) stopAnimating;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIView *backgroundView;

- (void) startAnimating;
- (void) stopAnimating;

@end
