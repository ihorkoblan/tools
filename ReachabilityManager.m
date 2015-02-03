//
//  ReachabilityManager.m
//  Appcident
//
//  Created by fuzza on 15.09.14.
//  Copyright (c) 2014 squarewolf. All rights reserved.
//

#import "ReachabilityManager.h"

@interface ReachabilityManager()

@property (nonatomic, strong) Reachability *reach;

@end

@implementation ReachabilityManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        [self.reach startNotifier];
    }
    return self;
}

-(void)reachabilityChanged:(id)notification
{
    if(![self.reach isReachable])
    {
        NSLog(@"Internet connection is down");
        self.isConnectionReachable = NO;
        [self showNoConnectionAlert];
    }
    else
    {
        self.isConnectionReachable = YES;
        NSLog(@"Internet connection is up");
    }
}

-(void)showNoConnectionAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"network-unavailable-title", nil)
                                                    message:NSLocalizedString(@"network-unavailable-body", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)checkOfflineModeWithSuccess:(void(^)())success failure:(void(^)())failure
{

    if(self.isConnectionReachable)
    {
        if(success)
        {
            success();
        }
    }
    else
    {
        [self showOfflineModeAlert];
        if(failure)
        {
            failure();
        }
    }
}

- (void)showOfflineModeAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"offline-mode-title", nil)
                                                    message:NSLocalizedString(@"offline-mode-body", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}



@end
