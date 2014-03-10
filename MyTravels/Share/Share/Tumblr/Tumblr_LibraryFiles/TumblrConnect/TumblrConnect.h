//
//  TumblrConnect.h
//  Tumblr
//
//  Created by Kashif Jilani on 12/30/12.
//  Copyright (c) 2012 Kashif Jilani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAConsumer.h"
#import "OAToken.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "JSON.h"
#import "Tumblr.h"

@class ViewController;

static NSString* kMyApplicationConsumerKey = @"pYdiUt3V5aJ8f1gZ9xJ5ordfW4IgB17Nf5jDJ4weuuM8hNFlKq";
static NSString* kMyApplicationConsumerSecret = @"nUX9QCGNe8c2Vigi8hjeWyzmES800Q6TybLE7wmlJRct5fpaTP";

#define kTumblrInfoURL                             @"http://api.tumblr.com/v2/user/info"
#define kTumblrAccessTokenDefaultsKey              @"tumblr_accesstoken_key"

@interface TumblrConnect : NSObject <UIWebViewDelegate> {
        
    OAConsumer* consumer;
    OAToken* requestToken;
    OAToken* accessToken;
    
    UIActivityIndicatorView *acitvityIndicator;
    
    ViewController *superController;

}
@property (nonatomic, weak)  ViewController *superController;

@property (nonatomic, retain) UIActivityIndicatorView *acitvityIndicator;
-(void)connectTumblr;

@end
