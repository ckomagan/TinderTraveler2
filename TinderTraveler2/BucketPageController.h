//
//  Home Page
//  <App name>
//
//  Created by Chan Komagan on 10/15/14.
//  Copyright (c) 2015 KidsIQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketPageController : UIViewController
 {
       NSMutableData *responseData;
 }

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *addGoalBtn;

@property (nonatomic) NSString *fbId;

-(IBAction)addGoal;
@end
