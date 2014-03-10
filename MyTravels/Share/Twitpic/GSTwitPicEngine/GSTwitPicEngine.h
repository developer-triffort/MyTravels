//
//  GSTwitPicEngine.h
//  TwitPic Uploader
//
//  Created by Gurpartap Singh on 19/06/10.
//  Copyright 2010 Gurpartap Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OAToken.h" 

#import "ASIHTTPRequest.h"


// Define these API credentials as per your applicationss.

// Get here: http://twitter.com/apps
#define TWITTER_OAUTH_CONSUMER_KEY @"SqAdyUQ1eVZBl3x9qSgXHA"     //aHk7XNp97jZwxCIqJWolsQ  oC7DnTwpxuww2DROXJeF6g
#define TWITTER_OAUTH_CONSUMER_SECRET @"ZATLmk2ZBjXJ3HlEKGL2KSc5oC5kLzpOvttx2oo2BA"   //XWjKcmpvyyqH5Q3vkjg3f48MUmgqiWNcUpNvZDbsUg ZATLmk2ZBjXJ3HlEKGL2KSc5oC5kLzpOvttx2oo2BA 6dwMQFGIrfjbD0qWWV9YhmwctGSdmjBpjP7i8HBY

// Get here: http://dev.twitpic.com/apps/
#define TWITPIC_API_KEY @"9845a4546666cf8f7ffce9c2fa8c3101"   //b373dba56f615cb4b2a1be3fa7df92e4  91f1c8fc840b9d5fb82967133cb84f38

// TwitPic API Version: http://dev.twitpic.com/docs/
#define TWITPIC_API_VERSION @"2"

// Enable one of the JSON Parsing libraries that the project has.
// Disable all to get raw string as response in delegate call to parse yourself.
#define TWITPIC_USE_YAJL 0
#define TWITPIC_USE_SBJSON 0
#define TWITPIC_USE_TOUCHJSON 1
#define TWITPIC_API_FORMAT @"json"

//  Implement XML here if you wish to.
//  #define TWITPIC_USE_LIBXML 0
//  #if TWITPIC_USE_LIBXML
//    #define TWITPIC_API_FORMAT @"xml"
//  #endif


@protocol GSTwitPicEngineDelegate

- (void)twitpicDidFinishUpload:(NSDictionary *)response;
- (void)twitpicDidFailUpload:(NSDictionary *)error;

@end

@class ASINetworkQueue;

@interface GSTwitPicEngine : NSObject <ASIHTTPRequestDelegate, UIWebViewDelegate> {
  __weak NSObject <GSTwitPicEngineDelegate> *_delegate;
  
	OAToken *_accessToken;
  
  ASINetworkQueue *_queue;
}

@property (retain) ASINetworkQueue *_queue;

+ (GSTwitPicEngine *)twitpicEngineWithDelegate:(NSObject *)theDelegate;
- (GSTwitPicEngine *)initWithDelegate:(NSObject *)theDelegate;

- (void)uploadPicture:(UIImage *)picture;
- (void)uploadPicture:(UIImage *)picture withMessage:(NSString *)message;

@end


@interface GSTwitPicEngine (OAuth)

- (void)setAccessToken:(OAToken *)token;

@end
