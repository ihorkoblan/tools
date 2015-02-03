//
//  ActivityIndicatorView.m
//  Appcident
//
//  Created by Dominik Ziajka on 11/17/13.
//  Copyright (c) 2013 squarewolf. All rights reserved.
//

#import "ActivityIndicatorView.h"

@implementation ActivityIndicatorView

static ActivityIndicatorView* sharedInstance = nil;
static NSMutableDictionary* map = nil;

+ (ActivityIndicatorView*) sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

+ (ActivityIndicatorView*) sharedInstanceWithImage: (NSString*) image  {
    if(map == nil) {
        map = [[NSMutableDictionary alloc] init];
    }
    
    if([map objectForKey:image] == nil) {
        [map setObject:[[super alloc] initWithImage: image] forKey:image];
    }

    return [map objectForKey:image];
}

- (id) initWithImage: (NSString*) image {
    if(self = [super init]) {
        _image = image;
    }
    return self;
}

- (id) init {
    if(self = [super init]) {
        _image = @"loading_indicator.png";
    }
    return self;
}

- (void) design: (NSString*) image {
    float margin = 15;
    
    UIWindow* window = [UIApplication sharedApplication].windows.firstObject;
    
    UIImage* background = [UIImage imageNamed:image];
    _backgroundView = [[UIImageView alloc] initWithImage:background];
    
    _backgroundView.frame = CGRectMake(window.frame.size.width - background.size.width - margin, window.frame.size.height - background.size.height - margin, background.size.width, background.size.height);
    
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGRect frame = _activityIndicator.frame;
    frame.origin.x = (_backgroundView.size.width - frame.size.width)/2.;
    frame.origin.y = (_backgroundView.size.height - frame.size.height)/2.;
    _activityIndicator.frame = frame;
    
    [_backgroundView addSubview:_activityIndicator];
    [self addSubview:_backgroundView];
    [window addSubview:self];
}

- (void) startAnimating {
    [self startAnimatingWithIndicator:YES];
}

- (void) startAnimatingWithIndicator: (BOOL) indicator {
    TF_PASS_CHECKPOINT(@"Start animating indicator");
    
    [self design:_image];
    if(indicator) {
        [_activityIndicator startAnimating];
    }
    self.hidden = FALSE;
}


- (void) stopAnimating {
    TF_PASS_CHECKPOINT(@"Called stop animating");
    [_activityIndicator stopAnimating];
    self.hidden = TRUE;
    [self removeAllSubviews];
    [self removeFromSuperview];
}

- (void) stopAnimatingAfter: (NSInteger) seconds {  
    [self performSelector:@selector(stopAnimating) withObject:nil afterDelay:seconds];
}

- (void) dealloc {
    TF_PASS_CHECKPOINT(@"Indicator deallocated");
}
@end
