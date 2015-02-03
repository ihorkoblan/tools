//
//  ActivityIndicatedImageView.m
//  Appcident
//
//  Created by Thomas Vervest on 29-06-12.
//  Copyright (c) 2012 squarewolf. All rights reserved.
//

#import "ActivityIndicatedImageView.h"

@implementation ActivityIndicatedImageView
{
    UIActivityIndicatorView *progressView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        progressView.hidesWhenStopped = YES;
        
        [self addSubview:progressView];
        
        [progressView startAnimating];
    }
    return self;
}

- (void)enableAnimations
{
    progressView.hidden = NO;
}

- (void)disableAnimations
{
    progressView.hidden = YES;
}

- (void)setImage:(UIImage *)image
{
    if (image)
    {
        [progressView stopAnimating];
    }
    else
    {
        [progressView startAnimating];
    }
    
    [super setImage:image];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat maxSize = MIN(self.frame.size.width, self.frame.size.height);
    if (progressView.frame.size.width > maxSize || progressView.frame.size.height > maxSize)
    {
        CGFloat size = MAX(maxSize - 4, maxSize * 0.9f);
        progressView.frame = CGRectMake((self.frame.size.width - size) / 2.0f,
                                        (self.frame.size.height - size) / 2.0f,
                                        size,
                                        size);
    }
    else
    {
        progressView.frame = CGRectMake((self.frame.size.width - progressView.frame.size.width) / 2.0f,
                                        (self.frame.size.height - progressView.frame.size.height) / 2.0f,
                                        progressView.frame.size.width,
                                        progressView.frame.size.height);
    }
}


@end
