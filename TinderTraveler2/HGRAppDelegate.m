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
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
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
    [FBSDKAppEvents activateApp];
    [FBSDKAccessToken currentAccessToken];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSDKAccessToken currentAccessToken];
}

@end
