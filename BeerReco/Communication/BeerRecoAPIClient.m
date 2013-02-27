//
//  BeerRecoAPIClient.m
//  BeerReco
//
//  Created by RLemberg on 2/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerRecoAPIClient.h"
#import "AFJSONRequestOperation.h"

@implementation BeerRecoAPIClient

@synthesize networkReachabilityStatus = _networkReachabilityStatus;

#pragma mark - Class Methods

+ (BeerRecoAPIClient *) sharedClient
{
    static BeerRecoAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BeerRecoAPIClient alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
        
        [_sharedClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
         {
             switch (status)
             {
                 case AFNetworkReachabilityStatusUnknown:
                     NSLog(@"AFNetworkReachabilityStatusUnknown");
                     break;
                 case AFNetworkReachabilityStatusNotReachable:
                     NSLog(@"AFNetworkReachabilityStatusNotReachable");
                     break;
                 case AFNetworkReachabilityStatusReachableViaWWAN:
                     NSLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
                     break;
                 case AFNetworkReachabilityStatusReachableViaWiFi:
                     NSLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
                     break;
                     
                 default:
                     NSLog(@"AFNetworkReachabilityStatusUnknown");
                     break;
             }
             
             _sharedClient.networkReachabilityStatus = status;
             
             if (status >= AFNetworkReachabilityStatusUnknown && status <= AFNetworkReachabilityStatusReachableViaWiFi)
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_NetworkStatusChanged object:nil userInfo:nil];
             }
         }];
    });
    
    return _sharedClient;
}

+ (NSString*) getFullPathForFile:(NSString*)filePath
{
    return [NSString stringWithFormat:@"%@%@", BaseURL_FileServer, filePath];
}

+ (BOOL) serverDownCode:(int)code
{
    if (code == GlobalCommunicationError_CouldNotConnectToServer || code == GlobalCommunicationError_ReuqestTimeOut)
    {
        YES;
    }
    
    return NO;
}

#pragma Mark - Instance Methods

- (id) initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self)
    {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (BOOL) isNetworkReachable
{
    return self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN || self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

- (void)performRequestMethod:(NSString*)method
                        path:(NSString *)path
                  parameters:(NSDictionary *)parameters
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self performRequestMethod:method path:path parameters:parameters withInterval:0 success:success failure:failure];
}

- (void)performRequestMethod:(NSString*)method
                        path:(NSString *)path
                  parameters:(NSDictionary *)parameters
                withInterval:(NSTimeInterval)interval
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSString* fixedPath = [NSString stringWithFormat:@"%@%@", BaseIphonePathPrefix, path];
    NSMutableURLRequest *request = [self requestWithMethod:method path:fixedPath parameters:parameters];
    
    if (interval > 0)
    {
        [request setTimeoutInterval:interval];
    }
    
    NSLog(@"request [%@]",request);
    
    // Setting a proxy block for success and failure
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             if (success)
                                             {
                                                 success(operation, responseObject);
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             NSLog(@"%@", error);
                                             
                                             if (failure)
                                             {
                                                 failure(operation, error);
                                             }
                                         }];
    
    if (!NetworkConfig_ShouldUseCache)
    {
        [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
            return nil;
        }];
    }
    
    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - Overrides

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self performRequestMethod:@"GET" path:path parameters:parameters success:success failure:failure];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self performRequestMethod:@"POST" path:path parameters:parameters success:success failure:failure];
}

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self performRequestMethod:@"PUT" path:path parameters:parameters success:success failure:failure];
}

- (void)deletePath:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self performRequestMethod:@"DELETE" path:path parameters:parameters success:success failure:failure];
}

- (void)patchPath:(NSString *)path
       parameters:(NSDictionary *)parameters
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self performRequestMethod:@"PATCH" path:path parameters:parameters success:success failure:failure];
}

#pragma mark - Overrides With Diff

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
   withInterval:(NSTimeInterval)interval
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{    
	[self performRequestMethod:@"GET" path:path parameters:parameters withInterval:interval success:success failure:failure];
}

/*
 AFNetworkReachabilityStatusUnknown          = -1,
 AFNetworkReachabilityStatusNotReachable     = 0,
 AFNetworkReachabilityStatusReachableViaWWAN = 1,
 AFNetworkReachabilityStatusReachableViaWiFi = 2,
 */

@end
