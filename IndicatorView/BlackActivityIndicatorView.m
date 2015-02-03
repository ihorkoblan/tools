//
//  BlackActivityIndicatorView.m
//  Appcident
//
//  Created by fuzza on 01.04.14.
//  Copyright (c) 2014 squarewolf. All rights reserved.
//

#import "BlackActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@implementation BlackActivityIndicatorView

static BlackActivityIndicatorView* sharedInstance = nil;
static NSMutableDictionary* map = nil;

+ (instancetype) sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) startAnimating
{
    [self setup];
    [self.indicator startAnimating];
    self.hidden = NO;
}

- (void) stopAnimating
{
    [self.indicator stopAnimating];
    self.hidden = YES;
    [self removeAllSubviews];
    [self removeFromSuperview];
}

-(void)setup
{
    UIWindow* window = [UIApplication sharedApplication].windows.firstObject;
    
    CGFloat backgroundSize = 80.f;
    
    self.backgroundView = [[UIImageView alloc] initWithFrame: CGRectMake((window.frame.size.width - backgroundSize)/2., (window.frame.size.height - 64.f - backgroundSize)/2., backgroundSize, backgroundSize)];
    
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.7f;
    self.backgroundView.layer.cornerRadius = 5;
    self.backgroundView.layer.masksToBounds = YES;
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect frame = self.indicator.frame;
    frame.origin.x = (self.backgroundView.size.width - frame.size.width)/2.;
    frame.origin.y = (self.backgroundView.size.height - frame.size.height)/2.;
    self.indicator.frame = frame;

    [self.backgroundView addSubview:self.indicator];
    
    [self addSubview:self.backgroundView];
    [window addSubview:self];
}

@end
