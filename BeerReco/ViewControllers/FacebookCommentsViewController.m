//
//  FacebookCommentsViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FacebookCommentsViewController.h"
#import "AppDelegate.h"

@interface FacebookCommentsViewController ()

@end

@implementation FacebookCommentsViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoggedIn:) name:GlobalMessage_FB_LoggedIn object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoggedOut:) name:GlobalMessage_FB_LoggedOut object:nil];
    
    [self visualSetup];
    
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setFacebookCommentsView:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods

-(void)visualSetup
{
}

-(void)setup
{
    self.facebookCommentsView.href = [NSURL URLWithString:self.objectId];
    self.facebookCommentsView.numbeOfPosts = 5;
    self.facebookCommentsView.showFaces = NO;
    
    self.facebookCommentsView.alpha = 0;
    [self.facebookCommentsView load];
}

#pragma mark - Notifications Handlers

-(void)facebookLoggedIn:(NSNotification*)notification
{
    self.facebookCommentsView.alpha = 1;
    [self.facebookCommentsView load];
}

-(void)facebookLoggedOut:(NSNotification*)notification
{
    self.facebookCommentsView.alpha = 1;
    [self.facebookCommentsView load];
}

#pragma mark FacebookCommentsViewDelegate methods

-(void)facebookCommentsView:(FacebookCommentsView *)aFacebookCommentsView didFailLoadWithError:(NSError *)error
{
}

- (void)facebookCommentsViewRequiresLogin:(FacebookCommentsView *)aFacebookCommentsView
{
    [[AppDelegate getMainApp] openSession];
}

- (void)facebookCommentsViewDidRender:(FacebookCommentsView *)aFacebookCommentsView
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    self.facebookCommentsView.alpha = 1;
    [UIView commitAnimations];
}

- (void)facebookCommentsViewDidCreateComment:(FacebookCommentsView *)aFacebookCommentsView
{
    
}

- (void)FacebookCommentsViewDidDeleteComment:(FacebookCommentsView *)aFacebookCommentsView
{
    
}

#pragma mark - Action Handlers

- (IBAction)doneClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
