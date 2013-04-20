//
//  CategoriesService.h
//  BeerReco
//
//  Created by RLemberg on 4/20/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BeerCategoryM.h"

@interface CategoriesService : NSObject

-(void)getAllCategories:(void (^)(NSMutableArray* categories, NSError *error))onComplete;

@end
