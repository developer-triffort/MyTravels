//
//  ViewController.h
//  Tumblr
//
//  Created by Kashif Jilani on 12/30/12.
//  Copyright (c) 2012 Kashif Jilani. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SVProgressHUD.h"

@class TumblrConnect;
@class UploadViewController;

@interface ViewController : UIViewController
{
    UINavigationController *navController;
    
    UIImage *tumblrImage;   // share image on tumblr
    NSString *tumblrCaption;    //caption for tumblr image
    
    NSMutableArray *blogsArray;
    
    NSString *OAuthKey;
    NSString *OAuthSecret;
   
    BOOL isPostSuccessfully;
    
}

@property (nonatomic, retain) NSString *OAuthKey;
@property (nonatomic, retain) NSString *OAuthSecret;
@property (nonatomic, retain) NSMutableArray *blogsArray;

@property (nonatomic, readwrite)  BOOL isPostSuccessfully;

@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) UIImage *tumblrImage;
@property (nonatomic, assign) NSString *tumblrCaption;


- (IBAction)dissMissController;
@end
