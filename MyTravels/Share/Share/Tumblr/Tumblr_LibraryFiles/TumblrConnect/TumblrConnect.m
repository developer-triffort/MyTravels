//
//  TumblrConnect.m
//  Tumblr
//
//  Created by Kashif Jilani on 12/30/12.
//  Copyright (c) 2012 Kashif Jilani. All rights reserved.
//

#import "TumblrConnect.h"
#import "SVProgressHUD.h"
//#import "AppDelegate.h"
#import "ViewController.h"


@implementation TumblrConnect
@synthesize acitvityIndicator,superController;

-(void)connectTumblr {
    
    consumer = [[OAConsumer alloc] initWithKey:kMyApplicationConsumerKey secret:kMyApplicationConsumerSecret];
    
    NSURL* requestTokenUrl = [NSURL URLWithString:@"http://www.tumblr.com/oauth/request_token"];
    OAMutableURLRequest* requestTokenRequest = [[[OAMutableURLRequest alloc] initWithURL:requestTokenUrl
                                                                                consumer:consumer
                                                                                   token:nil
                                                                                   realm:nil
                                                                       signatureProvider:nil] autorelease];
    OARequestParameter* callbackParam = [[[OARequestParameter alloc] initWithName:@"oauth_callback" value:@"tumblr://authorized"] autorelease];
    [requestTokenRequest setHTTPMethod:@"POST"];
    [requestTokenRequest setParameters:[NSArray arrayWithObject:callbackParam]];
    OADataFetcher* dataFetcher = [[[OADataFetcher alloc] init] autorelease];
    [dataFetcher fetchDataWithRequest:requestTokenRequest
                             delegate:self
                    didFinishSelector:@selector(didReceiveRequestToken:data:)
                      didFailSelector:@selector(didFailOAuth:error:)];
    
    acitvityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    acitvityIndicator.frame = CGRectMake(0, 0, 100, 100);
   
    [[[UIApplication sharedApplication] keyWindow] addSubview:acitvityIndicator];
    acitvityIndicator.center = [[UIApplication sharedApplication] keyWindow].center;
    [acitvityIndicator startAnimating];


}

- (void)didReceiveRequestToken:(OAServiceTicket*)ticket data:(NSData*)data {
    
    
    NSString* httpBody = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
    NSURL* authorizeUrl = [NSURL URLWithString:@"https://www.tumblr.com/oauth/authorize"];
    OAMutableURLRequest* authorizeRequest = [[[OAMutableURLRequest alloc] initWithURL:authorizeUrl
                                                                             consumer:nil
                                                                                token:nil
                                                                                realm:nil
                                                                    signatureProvider:nil] autorelease];
    NSString* oauthToken = requestToken.key;
    OARequestParameter* oauthTokenParam = [[[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken] autorelease];
    [authorizeRequest setParameters:[NSArray arrayWithObject:oauthTokenParam]];
    
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webView.scalesPageToFit = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:webView];
    
    webView.alpha = 0.5;
    
    webView.delegate = self;
    [webView loadRequest:authorizeRequest];
    [webView release];
    
}

- (void)didReceiveAccessToken:(OAServiceTicket*)ticket data:(NSData*)data {
    
    //AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString* httpBody = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
    //delegate.OAuthKey = accessToken.key;
   // delegate.OAuthSecret = accessToken.secret;
    
    superController.OAuthKey = accessToken.key;
    superController.OAuthSecret = accessToken.secret;
    
    OAConsumer *consumerKey = [[OAConsumer alloc] initWithKey:TUMBLR_OUTH_KEY secret:TUMBLR_OUTH_SECRET_KEY];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kTumblrInfoURL]];
    
    //OAToken *authToken = [[OAToken alloc] initWithKey:delegate.OAuthKey secret:delegate.OAuthSecret];
    OAToken *authToken = [[OAToken alloc] initWithKey:superController.OAuthKey secret:superController.OAuthSecret];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumerKey
                                                                      token:authToken
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    [consumer release];
    [authToken release];
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(infoTicket:didFinishWithData:)
                  didFailSelector:@selector(infoTicket:didFailWithError:)];

    // FINISHED!
}

- (void)infoTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
   // AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *responseDict = [responseBody JSONValue];
    
    NSDictionary *dict = [responseDict valueForKey:@"response"];
    NSDictionary *userDict = [dict valueForKey:@"user"];
    NSDictionary *blogs = [userDict valueForKey:@"blogs"];
    
    for(id key in blogs) {
        
        NSString *blogName = [key objectForKey:@"name"];
        //[delegate.blogsArray addObject:blogName];
        [superController.blogsArray addObject:blogName];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moveToUpload" object:nil];
}

- (void)infoTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    NSLog(@"Tumblr Request Token Failed - %@", error.description);
}


- (void)didFailOAuth:(OAServiceTicket*)ticket error:(NSError*)error {
    // ERROR!
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {

    if ([[[request URL] scheme] isEqualToString:@"tumblr"]) {
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"oauth_verifier"]) {
                verifier = [keyValue objectAtIndex:1];
                [SVProgressHUD dismiss];
                break;
            }
        }
        
        if (verifier) {
            NSURL* accessTokenUrl = [NSURL URLWithString:@"https://www.tumblr.com/oauth/access_token"];
            OAMutableURLRequest* accessTokenRequest = [[[OAMutableURLRequest alloc] initWithURL:accessTokenUrl
                                                                                       consumer:consumer
                                                                                          token:requestToken
                                                                                          realm:nil
                                                                              signatureProvider:nil] autorelease];
            OARequestParameter* verifierParam = [[[OARequestParameter alloc] initWithName:@"oauth_verifier" value:verifier] autorelease];
            [accessTokenRequest setHTTPMethod:@"POST"];
            [accessTokenRequest setParameters:[NSArray arrayWithObject:verifierParam]];
            OADataFetcher* dataFetcher = [[[OADataFetcher alloc] init] autorelease];
            [dataFetcher fetchDataWithRequest:accessTokenRequest
                                     delegate:self
                            didFinishSelector:@selector(didReceiveAccessToken:data:)
                              didFailSelector:@selector(didFailOAuth:error:)];
            
            [acitvityIndicator removeFromSuperview];
            [acitvityIndicator stopAnimating];
            
        } else {
            // ERROR!
        }
        
        [webView removeFromSuperview];
       
        return NO;
    }
return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [acitvityIndicator removeFromSuperview];
    [acitvityIndicator stopAnimating];
    webView.alpha = 1.0;
}
- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    [acitvityIndicator removeFromSuperview];
    [acitvityIndicator stopAnimating];

    // ERROR!
}


@end
