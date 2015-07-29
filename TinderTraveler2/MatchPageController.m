//
//  MatchPController.m
//  KidsIQ3
//
//  Created by Chan Komagan on 7/28/12.
//  Copyright (c) 2012 KidsIQ. All rights reserved.
//

#import "MatchPageController.h"
#import "HomePageController.h"
#import "MatchAlertController.h"
#import "SettingsController.h"
#import "ChoosePersonViewController.h"
#import "Person.h"
#import "MDCSwipeToChoose.h"
#import <Foundation/Foundation.h>

static const CGFloat ChoosePersonButtonHorizontalPadding = 0.f;
static const CGFloat ChoosePersonButtonVerticalPadding = -15.f;

@interface MatchPageController ()
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSString *nsURL;
@property (nonatomic, strong) UIView *topView;
@end

@implementation MatchPageController
@synthesize fbId;
@synthesize urlPrefix;
@synthesize responseData;
@synthesize profilePictureView;
@synthesize nsURL = _nsURL;
NSDictionary *res;

#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
       // _people = [[self defaultPeople] mutableCopy];
        _people = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 self.fbId = result[@"id"];
                 self.emailId = result[@"email"];
                 
                 NSLog(@"resultis:%@",result);
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
    }

    self.fbId = @"10152713399375155";
    NSString *post = [NSString stringWithFormat:@"&fbId=%@", self.fbId];
  
    _nsURL = @"http://www.komagan.com/TinderTraveler/index.php?format=json&operation=match";
    _nsURL = [_nsURL stringByAppendingString:post];

    NSLog(@"URL=%@", _nsURL);
    
    self.responseData = [NSMutableData data];
    
    NSURLRequest *aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: _nsURL]];
   
    [[NSURLConnection alloc] initWithRequest:aRequest delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.responseData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *myError = nil;
    res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    for(NSDictionary *res1 in res) {
        NSString *matchfbId = [res1 objectForKey:@"matchfbId"];
        NSString *name = [res1 objectForKey:@"name"];
        NSString *emailId = [res1 objectForKey:@"emailId"];
        NSString *location = [res1 objectForKey:@"travelcity"];
        NSUInteger age = [[res1 objectForKey:@"age"] intValue];
        NSString *photo = [res1 objectForKey:@"mainphoto"];
        NSString *fromDate = [res1 objectForKey:@"fromDate"];
        NSString *toDate = [res1 objectForKey:@"toDate"];
        NSURL *imageUrl = [NSURL URLWithString: [@"http://komagan.com/TinderTraveler/" stringByAppendingString:photo]];
        
        NSData *data = [NSData dataWithContentsOfURL:imageUrl];
        UIImage *image = [UIImage imageWithData:data];
        [profilePictureView setImage:image];
        Person *person = [[Person alloc] initWithName:matchfbId
                              name:name
                        emailId:emailId
                      location:location
                                age:age
                            image:image
                            fromDate:fromDate
                            toDate:toDate
                numberOfSharedFriends:3
              numberOfSharedInterests:2
                       numberOfPhotos:1];
        [self.people addObject:person];
    }

    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    [self constructSettingsButton];
    [self constructChatButton];
    [self constructLikeMessageText];
    [self constructNopeButton];
    [self constructLikedButton];
}

-(IBAction)settingsBtn:(id)sender {
    [self performSegueWithIdentifier:@"HomePage" sender:self];    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"HomePage"]) {
        
        HomePageController *homePageView = segue.destinationViewController;
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentPerson.name);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
     if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentPerson.name);
        [self addtoNopeList];
    } else {
        NSLog(@"You liked %@.", self.currentPerson.name);
        [self addToLikeList];
        [self showMatchAlert:self.currentPerson];
    }
     self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(ChoosePersonView *)frontCardView {
    _frontCardView = frontCardView;
    self.currentPerson = frontCardView.person;
}

- (ChoosePersonView *)popPersonViewWithFrame:(CGRect)frame {
   
    if ([self.people count] == 0) {
        return nil;
    }
    
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                    person:self.people[0]
                                                                   options:options];
    [self.people removeObjectAtIndex:0];
    return personView;
}

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 100.f;
    CGFloat bottomPadding = 220.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 5.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

- (CGRect)bottomCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 180.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

- (void)constructLikeMessageText {
    UILabel *statusLabel;
    
    CGFloat horizontalPadding = 80.f;
    CGFloat topPadding = 0.f;
    CGFloat bottomPadding = 410.f;
    CGRect frame = CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - horizontalPadding,
                      CGRectGetHeight(self.view.frame) - bottomPadding);
    
    statusLabel = [[UILabel alloc] initWithFrame:frame];
    statusLabel.text = @"She matches your goal";
    statusLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:statusLabel];
}

- (void)constructSettingsButton {
    CGFloat horizontalPadding = 220.f;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"settings"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width + horizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) - 390,
                              image.size.width/14,
                              image.size.height/14);
    [button addTarget:self
               action:@selector(settingsView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)constructChatButton {
    CGFloat horizontalPadding = 190.f;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"chat"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width + horizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) - 390,
                              image.size.width/7,
                              image.size.height/7);
    [button addTarget:self
               action:@selector(chatView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"like2"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding + 237,
                              CGRectGetMaxY(self.backCardView.frame) - ChoosePersonButtonVerticalPadding,
                              image.size.width/5,
                              image.size.height/5);
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"nope"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding + 270,
                              CGRectGetMaxY(self.backCardView.frame) - ChoosePersonButtonVerticalPadding,
                              image.size.width/6,
                              image.size.height/6);
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)settingsView {
    SettingsController *settingsView = [[SettingsController alloc] initWithNibName:@"SettingsPage" bundle:nil];
    settingsView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:settingsView animated:YES completion:nil];
}

- (void)chatView {
    /*ChatController *chatView = [[SettingsController alloc] initWithNibName:@"SettingsController" bundle:nil];
    settingsView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:settingsView animated:YES completion:nil];*/
}

- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

- (void)addToLikeList {
    
    [self performLikeNopeHandler:@"like": self.currentPerson];
}

- (void)addtoNopeList {
    [self performLikeNopeHandler:@"nope": self.currentPerson];
}

- (void)performLikeNopeHandler:(NSString*)option : (Person *)person
{
    _nsURL = @"http://www.komagan.com/TinderTraveler/index.php?format=json&operation=";
    _nsURL = [NSString stringWithFormat:@"%@%@%@%@%@%@", _nsURL, option, @"&fbId=", fbId, @"&matchfbId=", person.fbId];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:_nsURL]];
    [NSURLConnection sendAsynchronousRequest:request
                                   queue:[NSOperationQueue mainQueue]
                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                           if(data.length) {
                               NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               if(responseString && responseString.length) {
                                   NSLog(@"%@", responseString);
                               }
                           }
                       }];
}

-(void) showMatchAlert: (Person *)person {
    MatchAlertController *matchAlertView = [[MatchAlertController alloc] initWithNibName:@"MatchAlert" bundle:nil];
    matchAlertView.matchName = person.name;
    matchAlertView.matchGoalLocation = person.location;
    matchAlertView.matchProfileImage = person.image;
    //matchAlertView.myProfileImage =
    matchAlertView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:matchAlertView animated:YES completion:nil];
    }

@end
