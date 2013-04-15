//
//  BeerRecoAPIClient.m
//  BeerReco
//
//  Created by RLemberg on 2/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerRecoAPIClient.h"
#import "AFJSONRequestOperation.h"

@interface BeerRecoAPIClient ()

@property (nonatomic, strong) NSSet* trustedHosts;

@end

@implementation BeerRecoAPIClient

@synthesize trustedHosts = _trustedHosts;

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
    
    self.parameterEncoding = AFJSONParameterEncoding;
    
    self.trustedHosts = [[NSSet alloc] initWithObjects:TrustedServerHost, nil];
    
    return self;
}

- (BOOL) isNetworkReachable
{
    return self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN || self.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

- (void) setSessionTypeHeaderVariablesOnRequest:(NSMutableURLRequest*)request
{
    /*
    NSLog(@"User Public Key is: %@", [GeneralDataStore sharedDataStore].UserPublicKey);
    [request setValue:[GeneralDataStore sharedDataStore].UserPublicKey forHTTPHeaderField:HTTPHeaderParam_UserIdAuth];
    
    [request setValue:[GeneralDataStore sharedDataStore].isInSystemMode ? TrueStr : FalseStr forHTTPHeaderField:HTTPHeaderParam_Sandbox];
    
    if ([GeneralDataStore sharedDataStore].isInSystemMode)
    {
        NSLog(@"preprod mode: '%@'", [GeneralDataStore sharedDataStore].isInPreProdMode ? TrueStr : FalseStr);
        [request setValue:[GeneralDataStore sharedDataStore].isInPreProdMode ? TrueStr : FalseStr forHTTPHeaderField:HTTPHeaderParam_PreProd];
    }
     */
}

- (void)performRequestMethod:(NSString*)method
                        path:(NSString *)path
                  parameters:(NSDictionary *)parameters
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self performRequestMethod:method path:path parameters:parameters withInterval:0 withCompletionBlockQueue:nil success:success failure:failure];
}

- (void)performRequestMethod:(NSString*)method
                        path:(NSString *)path
                  parameters:(NSDictionary *)parameters
                withInterval:(NSTimeInterval)interval
    withCompletionBlockQueue:(dispatch_queue_t)completionQueue
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString* fixedPath = [NSString stringWithFormat:@"%@%@", BaseIpadPathPrefix, path];
    NSMutableURLRequest *request = [self requestWithMethod:method path:fixedPath parameters:parameters];
    [self setSessionTypeHeaderVariablesOnRequest:request];
    
    [request setTimeoutInterval:(interval > 0) ? interval : ServerReacabilityDefaultTimeout];
    
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
        [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse)
         {
             return nil;
         }];
    }
    
    if (NetworkConfig_MenualSSLAuthorization)
    {
        [operation setAuthenticationAgainstProtectionSpaceBlock:^BOOL(NSURLConnection *connection, NSURLProtectionSpace *protectionSpace)
         {
             return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
         }];
        
        [operation setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge)
         {
             if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
             {
                 
                 NSLog(@"%@", challenge.protectionSpace.host);
                 
                 if ([self.trustedHosts containsObject:challenge.protectionSpace.host])
                 {
                     [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
                     
                     return;
                 }
             }
             
             [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
         }];
    }
    
    if (completionQueue != nil)
    {
        [operation setFailureCallbackQueue:(completionQueue)];
        [operation setSuccessCallbackQueue:(completionQueue)];
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
	[self performRequestMethod:@"GET" path:path parameters:parameters withInterval:interval withCompletionBlockQueue:nil success:success failure:failure];
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
withCompletionBlockQueue:(dispatch_queue_t)completionQueue
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	[self performRequestMethod:@"GET" path:path parameters:parameters withInterval:0 withCompletionBlockQueue:completionQueue success:success failure:failure];
}

- (void)putPath:(NSString *)path
     parameters:(NSDictionary *)parameters
withCompletionBlockQueue:(dispatch_queue_t)completionQueue
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	[self performRequestMethod:@"PUT" path:path parameters:parameters withInterval:0 withCompletionBlockQueue:completionQueue success:success failure:failure];
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
   withInterval:(NSTimeInterval)interval
withCompletionBlockQueue:(dispatch_queue_t)completionQueue
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	[self performRequestMethod:@"GET" path:path parameters:parameters withInterval:interval withCompletionBlockQueue:completionQueue success:success failure:failure];
}

/*
 AFNetworkReachabilityStatusUnknown          = -1,
 AFNetworkReachabilityStatusNotReachable     = 0,
 AFNetworkReachabilityStatusReachableViaWWAN = 1,
 AFNetworkReachabilityStatusReachableViaWiFi = 2,
 */

@end
