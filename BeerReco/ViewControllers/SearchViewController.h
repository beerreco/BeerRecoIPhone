//
//  SecondViewController.h
//  BeerReco
//
//  Created by RLemberg on 2/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segSearch;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)segValueChanged:(id)sender;

@end
