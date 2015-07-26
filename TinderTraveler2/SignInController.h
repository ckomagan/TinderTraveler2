//
//  SignInController.h
//  TinderTraveler
//
//  Created by Chan Komagan on 10/18/14.
//  Copyright (c) 2014 Chan Komagan. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SignInController : UIViewController <FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginView;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet FBSDKProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSString *objectID;
@property (nonatomic) NSString *fbId;
@property (nonatomic) NSString *emailId;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userLocation;
@property (nonatomic) NSString *userBirthDay;
@property (nonatomic) int userAge;
@property (nonatomic) NSString *userGender;
@property (nonatomic) NSString *userZip;
@property (nonatomic, strong) NSString *nsURL;
@property (nonatomic, retain) NSMutableData *responseData;
@property (strong, nonatomic) UIWindow *window;

-(void)createUser;
-(void)calculateAge;

@end
