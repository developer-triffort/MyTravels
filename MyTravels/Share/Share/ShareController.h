//
//  ShareController.h
//  MyTavels?
//
//  Created by Rahul Jain on 18/10/12.
//  Copyright (c) 2012 rahul kuamr jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h> 
#import "Appirater.h"
#define Itunes_URL @"https://itunes.apple.com/us/app/mytravels/id602075836?ls=1&mt=8"
@class ViewController;


@interface ShareController : NSObject<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    id supercontroller;
    
    ViewController *viewController;

}
//@property(retain) OAToken *requestToken;
@property (nonatomic, assign) id supercontroller;
@property (atomic, assign) UIImage *tumblrImage;
@property (nonatomic, retain) ViewController *viewController;

+ (ShareController *) sharedInstance;

+ (BOOL) isNetworkAvilable;

- (void) shareWithTwitter : (NSString *) shareMessage viewController: (UIViewController*)viewcontroller shareImage:(UIImage *)image;

- (void) shareWithFacebook : (NSString *) shareMessage viewController:(UIViewController *)controller shareImage:(UIImage*)image;

- (void) savedImageInAlbum: (UIImage *)currentImage;

-(void) shareWithMail :(NSString *) shareMessage:(UIViewController *) selfController:(NSString *)subjectName attachent:(UIImage *)image;

- (void) shareWithTumblr : (NSString *) shareMessage viewController:(UIViewController *)controller shareImage:(UIImage*)image;
@end
