//
//  CommentsService.h
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsService : NSObject

-(void)getCommentsCountForObject:(NSString*)objectId onComplete:(void (^)(int count, NSError *error))onComplete;

@end
