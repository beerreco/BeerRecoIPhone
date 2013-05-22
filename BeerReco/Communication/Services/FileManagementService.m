//
//  FileManagementService.m
//  BeerReco
//
//  Created by RLemberg on 4/25/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FileManagementService.h"

#define FileUploadService @"FileUpload/UploadFileHandler.ashx"

#define QueryParam_FileName @"fileName"
#define QueryParam_ImageOf @"imageOf"
#define QueryParam_ItemId @"itemId"

@implementation FileManagementService

-(void)uploadFile:(UIImage*)imageFile ofEntity:(NSString*)imageOf onComplete:(void (^)(NSString* filePath, NSError *error))onComplete
{
    NSString* fileName = @"beerreco.png";
    
    NSDictionary* params = @{QueryParam_FileName:fileName,QueryParam_ImageOf: imageOf, QueryParam_ItemId: [NSString uuid]};
    
    NSURL *baseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BaseURL_FileServer, FileUploadService]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseUrl];
    
    UIImage* scaledImage = [self image:imageFile ByScalingToSize:CGSizeMake(120, 120)];
    
    if (scaledImage == nil)
    {
        if (onComplete)
        {
            onComplete(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
            return;
        }
    }
    
    NSData *imageData = UIImagePNGRepresentation(scaledImage);
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
    {
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:fileName mimeType:@"image/png"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@", operation.responseString);
        if (onComplete)
        {
            onComplete(operation.responseString, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (onComplete)
        {
            onComplete(nil, error);
        }
    }];
    
    [httpClient enqueueHTTPRequestOperation:operation];
}

- (UIImage *)image:(UIImage*)sourceImage ByScalingToSize:(CGSize)targetSize
{    
    UIImage *newImage = nil;
    
    //   CGSize imageSize = sourceImage.size;
    //   CGFloat width = imageSize.width;
    //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

@end
