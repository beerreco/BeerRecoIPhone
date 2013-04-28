//
//  CommentsService.m
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "CommentsService.h"
#import "AFJSONRequestOperation.h"

#define FacebookGraphBase @"https://graph.facebook.com/"

#define QueryParam_Ids @"ids"

@implementation CommentsService

-(void)getCommentsCountForObject:(NSString*)objectId onComplete:(void (^)(int count, NSError *error))onComplete
{
    NSString* path = [NSString stringWithFormat:@"%@?%@=%@", FacebookGraphBase, QueryParam_Ids, objectId];
    
    NSLog(@"%@", path);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        id objectInfo = [JSON valueForKey:objectId];
        int count = [[objectInfo valueForKey:@"comments"] intValue];
        
        if (onComplete)
        {
            onComplete(count, nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    {
        if (onComplete)
        {
            onComplete(0, error);
        }
    }];
    
    [operation start];
}

@end
