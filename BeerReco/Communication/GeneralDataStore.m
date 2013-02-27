//
//  GeneralDataStore.m
//  BeerReco
//
//  Created by RLemberg on 2/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "GeneralDataStore.h"

@implementation GeneralDataStore

+ (GeneralDataStore *)sharedDataStore
{
    static GeneralDataStore *_sharedDataStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[GeneralDataStore alloc] init];
    });
    
    return _sharedDataStore;
}

@end
