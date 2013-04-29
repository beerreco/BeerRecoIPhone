//
//  FacebookCommentsView.m
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FacebookCommentsView.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookCommentsView () <UIWebViewDelegate>

- (void)initCommon;

@end


@implementation FacebookCommentsView

@synthesize href = _href;
@synthesize layout = _layout;
@synthesize showFaces = _showFaces;
@synthesize action = _action, font=_font;
@synthesize colorScheme = _colorScheme;
@synthesize ref = _ref;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initCommon];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initCommon];
    }
    return  self;
}

- (void)dealloc
{
    self.href = nil;
    self.layout = nil;
    self.action = nil;
    self.font = nil;
    self.colorScheme = nil;
    self.ref = nil;
    self.webView = nil;
}

- (void)initCommon
{
    _webView = [[UIWebView alloc] init];
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.delegate = self;
    [self addSubview:_webView];
    
    // Prevent web view from scrolling
    for (UIScrollView *subview in _webView.subviews)
    {
        if ([subview isKindOfClass:[UIScrollView class]])
        {
            subview.scrollEnabled = YES;
            subview.bounces = YES;
        }
    }
    
    // Default settings
    self.href = [NSURL URLWithString:@"http://example.com"];
    self.layout = @"standard";
    self.showFaces = YES;
    self.action = @"like";
    self.font = @"arial";
    self.colorScheme = @"light";
    self.ref = @"";
}

- (void)load
{
    NSString *htmlFormat = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FBComments" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
    
    NSString *html = [NSString stringWithFormat:htmlFormat,
                      self.href.absoluteString,
                      self.frame.size.width,
                      self.numbeOfPosts];

    [self.webView loadHTMLString:html baseURL:self.href];
}

- (void)didFailLoadWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(facebookCommentsView:didFailLoadWithError:)])
    {
        [self.delegate facebookCommentsView:self didFailLoadWithError:error];
    }
}

- (void)didObserveFacebookEvent:(NSString *)fbEvent
{
    if ([fbEvent isEqualToString:@"comment.create"] &&
        [self.delegate respondsToSelector:@selector(facebookCommentsViewDidCreateComment:)])
    {
        [self.delegate facebookCommentsViewDidCreateComment:self];
    }
    else if ([fbEvent isEqualToString:@"comment.remove"] &&
             [self.delegate respondsToSelector:@selector(FacebookCommentsViewDidDeleteComment:)])
    {
         [self.delegate FacebookCommentsViewDidDeleteComment:self];
    }
    else if ([fbEvent isEqualToString:@"xfbml.render"] &&
             [self.delegate respondsToSelector:@selector(facebookCommentsViewDidRender:)])
    {
        [self.delegate facebookCommentsViewDidRender:self];
    }
}

#pragma mark UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // Allow loading Like button XFBML from file
    if ([request.URL.host isEqual:self.href.host])
    {
        return YES;
    }
    
    // Allow loading about:blank, etc.
    if ([request.URL.scheme isEqualToString:@"about"])
    {
        return YES;
    }
    
    // Block loading of 'event:*', our scheme for forwarding Facebook JS SDK events to native code
    else if ([request.URL.scheme isEqualToString:@"event"])
    {
        [self didObserveFacebookEvent:request.URL.resourceSpecifier];
        return NO;
    }
    
    // Block redirects to non-Facebook URLs (e.g., by public wifi access points)
    else if (![request.URL.host hasSuffix:@"facebook.com"] && ![request.URL.host hasSuffix:@"fbcdn.net"])
    {
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"FacebookCommentsView was redirected to a non-Facebook URL.", NSLocalizedDescriptionKey,
                                   request.URL, NSURLErrorKey,
                                   nil];
        NSError *error = [NSError errorWithDomain:@"FacebookCommentsView"
                                             code:0
                                         userInfo:errorInfo];
        [self didFailLoadWithError:error];
        return NO;
    }
    
    // Block redirects to the Facebook login page and notify the delegate that we've done so
    else if ([request.URL.path isEqualToString:@"/login.php"])
    {
        [self.delegate facebookCommentsViewRequiresLogin:self];
        return NO;
    }
    
    else
    {
        return YES;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self didFailLoadWithError:error];
}

#pragma mark UIView methods

- (void)layoutSubviews
{
    // Due to an apparent iOS bug, layoutSubviews is sometimes called outside the main thread.
    // See https://devforums.apple.com/message/575760#575760
    if ([NSThread isMainThread])
    {
        self.webView.frame = self.bounds;
    }
}

@end
