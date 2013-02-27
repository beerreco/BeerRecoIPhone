//
//  BeerRecoAPIClient.h
//  BeerReco
//
//  Created by RLemberg on 2/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface BeerRecoAPIClient : AFHTTPClient

#define NetworkConfig_ShouldUseCache NO

#define BaseIphonePathPrefix @""

// Server
#define BaseURL @"http://85.119.5.11:9888/"
#define BaseURL_FileServer @"http://85.119.5.11/Files/"

+ (BeerRecoAPIClient*)sharedClient;

+ (NSString*)getFullPathForFile:(NSString*)filePath;

+ (BOOL) serverDownCode:(int)code;

@property (nonatomic) AFNetworkReachabilityStatus networkReachabilityStatus;

-(BOOL)isNetworkReachable;

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
   withInterval:(NSTimeInterval)interval
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
