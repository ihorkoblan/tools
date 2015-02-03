//
//  ReachabilityManager.h
//  Appcident
//
//  Created by fuzza on 15.09.14.
//  Copyright (c) 2014 squarewolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityManager : NSObject

@property (nonatomic, assign) BOOL isConnectionReachable;

- (void)checkOfflineModeWithSuccess:(void(^)())success failure:(void(^)())failure;
- (void)showNoConnectionAlert;

@end
