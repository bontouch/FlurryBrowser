//
//  AppDelegate.m
//  FlurryBrowser
//
//  Created by Emre Ergenekon on 7/17/12.
//  Copyright (c) 2012 Bontouch AB, Codely HB. All rights reserved.
//

#import "AppDelegate.h"
#import "FlurryAnalytics.h"
#import "FlurryKey.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FlurryAnalytics startSession:FLURRY_KEY];
    [FlurryAnalytics setSessionReportsOnPauseEnabled:YES];
    return YES;
}

@end
