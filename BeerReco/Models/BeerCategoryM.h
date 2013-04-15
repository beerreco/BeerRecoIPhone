//
//  BeerCategoryM.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeerCategoryM : NSObject

@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* name;

-(id)initWithJson:(NSDictionary*)json;

@end
