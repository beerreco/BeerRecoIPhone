//
//  FacebookCommentsView.h
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FacebookCommentsViewDelegate;

@interface FacebookCommentsView : UIView <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView* webView;

// A delegate
@property (nonatomic, strong) IBOutlet id<FacebookCommentsViewDelegate> delegate;

@property (nonatomic, strong) NSURL *href;

@property (nonatomic, strong) NSMutableDictionary *metaData;

@property (nonatomic) int numbeOfPosts;

// Load/reload the content of the web view. You should call this after changing any of the above parameters,
// and whenever the user signs in or out of Facebook.
- (void)load;

@end

@protocol FacebookCommentsViewDelegate <NSObject>

// Called when user taps Like button or "sign in" link when not logged in. Your implementation should present
// the user with a Facebook login dialog using either the Facebook iOS SDK or a separate web view. Once login
// is complete, you should refresh this view using [aFacebookLikeView load].
- (void)facebookCommentsViewRequiresLogin:(FacebookCommentsView *)aFacebookCommentsView;

@optional

// Called when the web view finishes rendering its XFBML content
- (void)facebookCommentsViewDidRender:(FacebookCommentsView *)aFacebookCommentsView;

// Called when the web view made a failed request or is redirected away from facebook.com
- (void)facebookCommentsView:(FacebookCommentsView *)aFacebookCommentsView didFailLoadWithError:(NSError *)error;

// Called when the user likes a URL via this view
- (void)facebookCommentsViewDidCreateComment:(FacebookCommentsView *)aFacebookCommentsView;

// Called when the user unlikes a URL via this view
- (void)FacebookCommentsViewDidDeleteComment:(FacebookCommentsView *)aFacebookCommentsView;

@end
