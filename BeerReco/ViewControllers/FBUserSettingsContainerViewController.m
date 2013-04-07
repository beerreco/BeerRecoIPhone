//
//  FBUserSettingsContainerViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/7/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FBUserSettingsContainerViewController.h"

@interface FBUserSettingsContainerViewController ()

@end

@implementation FBUserSettingsContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - FBUserSettingsDelegate methods

- (void)loginViewControllerDidLogUserOut:(id)sender
{
    // Facebook SDK * login flow *
    // There are many ways to implement the Facebook login flow.
    // In this sample, the FBLoginView delegate (SCLoginViewController)
    // will already handle logging out so this method is a no-op.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_FB_LoggedOut object:nil userInfo:nil];
}

- (void)loginViewControllerDidLogUserIn:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_FB_LoggedIn object:nil userInfo:nil];
}

- (void)loginViewController:(id)sender receivedError:(NSError *)error
{
    // Facebook SDK * login flow *
    // There are many ways to implement the Facebook login flow.
    // In this sample, the FBUserSettingsViewController is only presented
    // as a log out option after the user has been authenticated, so
    // no real errors should occur. If the FBUserSettingsViewController
    // had been the entry point to the app, then this error handler should
    // be as rigorous as the FBLoginView delegate (SCLoginViewController)
    // in order to handle login errors.
    if (error) {
        NSLog(@"Unexpected error sent to the FBUserSettingsViewController delegate: %@", error);
    }
}

@end
