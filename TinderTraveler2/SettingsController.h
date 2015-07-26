//
//  SettingsController.h
//  TinderTraveler
//
//  Created by Chan Komagan on 10/18/14.
//  Copyright (c) 2014 Chan Komagan. All rights reserved.
//

//#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController <FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginView;
@property (strong, nonatomic) IBOutlet FBSDKProfilePictureView *profilePictureView;
//@property (strong, nonatomic) id<FBSDKGraphRequest> loggedInUser;
@property (strong, nonatomic) NSString *objectID;
@property (nonatomic) NSString *fbId;
@property (nonatomic) NSString *emailId;
@property (nonatomic, strong) NSString *nsURL;
@property (nonatomic, retain) NSMutableData *responseData;

@end