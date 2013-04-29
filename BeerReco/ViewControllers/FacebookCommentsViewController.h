//
//  FacebookCommentsViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookCommentsView.h"

@interface FacebookCommentsViewController : UIViewController <FacebookCommentsViewDelegate>

@property (nonatomic, strong) NSString* objectId;

@property (weak, nonatomic) IBOutlet FacebookCommentsView *facebookCommentsView;

- (IBAction)doneClicked:(id)sender;

@end
