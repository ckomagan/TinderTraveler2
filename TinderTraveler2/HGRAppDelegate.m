//
//  HGRAppDelegate.m
//  TinderTraveler
//
//  Created by Chan Komagan on 10/15/14.
//  Copyright (c) 2014 Chan Komagan. All rights reserved.
//


#import "HGRAppDelegate.h"
#import "SignInController.h"
#import "SettingsController.h"

@implementation HGRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBSDKLoginButton class];
    [FBSDKProfilePictureView class];
    return YES;
}

/*
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    return wasHandled;
}
*/

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BFURL *parsedUrl = [BFURL URLWithInboundURL:url sourceApplication:sourceApplication];
    return parsedUrl;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAccessToken currentAccessToken];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSDKAccessToken currentAccessToken];
}

@end
