//
//  GeneralDataStore.h
//  BeerReco
//
//  Created by RLemberg on 2/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralDataStore : NSObject

+ (GeneralDataStore*)sharedDataStore;

@property (nonatomic, strong) NSString* FBUserID;

-(BOOL)hasFBUser;

@end
