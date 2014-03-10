//
//  AppDelegate.h
//  MyTravels
//
//  Created by Rahul kaumar Jain on 30/10/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import <AdSupport/ASIdentifierManager.h>
#import "Chartboost.h"
#import "AdWhirlView.h"
#import "AdWhirlDelegateProtocol.h"

@class CustomAlertView;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIDocumentInteractionControllerDelegate,ChartboostDelegate>
{
    
    UIStoryboard *storyBoard;
    AdWhirlView *adView;        // view for google ads
}

@property (strong, nonatomic) UIWindow *window;
@property (atomic, assign) UIImage *userImage;
@property (nonatomic, assign) UIImage *backImage;
@property (nonatomic,assign) UIImage *ImageForCaption;

@property (nonatomic, assign) NSString *fontName,*captionFontName;
@property (nonatomic, assign) UIColor *fontColor,*captionFontColo;
@property (nonatomic, assign) int fontSize,captionFontSize;
@property (nonatomic,retain)  UIView *splashView;
@property (nonatomic, retain) CustomAlertView *alertView;
@property (nonatomic, retain) NSTimer *timer;
@property (atomic, assign) BOOL isAlertOpen;
@property (nonatomic, assign) int fadeComplete;
@property (nonatomic, assign) AdWhirlView *adView;


@end
