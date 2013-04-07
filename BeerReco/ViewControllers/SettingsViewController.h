//
//  SettingsViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/7/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbSettings;

@end
