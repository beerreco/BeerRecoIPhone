//
//  BaseSearchAndRefreshTableViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PullToRefreshViewController.h"
#import "MBProgressHUD.h"
#import "LoadErrorViewController.h"

#import <Foundation/Foundation.h>

@interface BaseSearchAndRefreshTableViewController : PullToRefreshViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, MBProgressHUDDelegate, LoadErrorDelegate>

-(void)loadCurrentData;
-(NSString*)getSearchablePropertyName;
-(NSString*)getCellIdentifier;
-(void)setupCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath;
-(void)tableItemSelected:(NSIndexPath *)indexPath;
-(void)prepareForSegue:(UIStoryboardSegue *)segue withObject:(id)object;

@end
