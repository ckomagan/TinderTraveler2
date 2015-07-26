//
//  NameViewController.m
//  KidsIQ3
//
//  Created by Chan Komagan on 7/28/12.
//  Copyright (c) 2012 KidsIQ. All rights reserved.
//

#import "BucketPageController.h"

@implementation BucketPageController

NSString *levelSelection;
int challengeLevel = 1;
int noOfQuestions = 0;
#define LEGAL	@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{

}

-(IBAction)validateTextFields:(id)sender
{
    // make sure all fields are have something in them
    }

-(IBAction)dismissView {
    [self dismissModalViewControllerAnimated:YES];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //NSLog(@"%i", noOfQuestions);
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return (orientation != UIDeviceOrientationLandscapeLeft) &&
	(orientation != UIDeviceOrientationLandscapeRight);
}


@end
