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

//#define TrustedServerHost @"beerreco.appspot.com"
#define TrustedServerHost @"localhost:8888"

#define DateFromServerFormat @"MMM dd, yyyy hh':'mm':'ss a"

#define NetworkConfig_ShouldUseCache 0
#define NetworkConfig_UseSSLAuthorization 0
#define NetworkConfig_MenualSSLAuthorization 0

#define ServerReacabilityDefaultTimeout 30

#define HTTPHeaderParam_Sandbox @"sandbox"
#define HTTPHeaderParam_PreProd @"preprod"

#define BaseIpadPathPrefix @"rest"

#if NetworkConfig_UseSSLAuthorization
#define BaseURL [NSString stringWithFormat:@"https://%@/", TrustedServerHost]
#else
#define BaseURL [NSString stringWithFormat:@"http://%@/", TrustedServerHost]
#endif

#define BaseURL_FileServer @"http://db.cs.colman.ac.il/beerreco/"

+ (BeerRecoAPIClient*)sharedClient;

+ (NSString*)getFullPathForFile:(NSString*)filePath;

+ (BOOL) serverDownCode:(int)code;

#pragma Mark - Properties

@property (nonatomic) AFNetworkReachabilityStatus networkReachabilityStatus;

#pragma Mark - Instance Methods

-(BOOL)isNetworkReachable;

#pragma mark - Overrides With Diff

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
   withInterval:(NSTimeInterval)interval
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
withCompletionBlockQueue:(dispatch_queue_t)completionQueue
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
withCompletionBlockQueue:(dispatch_queue_t)completionQueue
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
   withInterval:(NSTimeInterval)interval
withCompletionBlockQueue:(dispatch_queue_t)completionQueue
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
