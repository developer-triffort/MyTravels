//
//  EditingViewController.h
//  MyTravels
//
//  Created by Rahul Jain on 18/10/12.
//  Copyright (c) 2012 rahul kuamr jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserView.h"
#import "UIImageExtras.h"
#import "UserResizableView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AccelerometerHelper.h"

#import "AdWhirlDelegateProtocol.h"
#import "AdWhirlView.h"

@class GrowingTextView;
@class UserView;

@interface EditingViewController : UIViewController <UITabBarDelegate, UITabBarControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate,UserResizableViewDelegate,UITextViewDelegate,UIAlertViewDelegate,UIAccelerometerDelegate,AdWhirlDelegate> {
    
    //UserView *userViewController;
    UserView *userViewController;
    CGPoint lastPoint;
	CGPoint currentPoint;
    
    BOOL isScrollingEnable;
    BOOL isEraserSelected;
    BOOL isUnEraserSelected;
    BOOL isScrollEnable;
    BOOL isDoubleTouch;
    BOOL isPushtoMoreScreen;
    int penWidth;
    int eraserWidth;
    
    NSMutableArray *unEraseArray;
    
    IBOutlet UIView *backView;
    
    IBOutlet UISlider *erserSlider;
    
    CGPoint startLocation;

    BOOL isFirstInstrustion;
    BOOL isPreview;
            
    SystemSoundID sound;
    
    UITouch *textViewTouch;
    
    AdWhirlView *adView;
}

@property (atomic, retain) UIImage *bgImage;

@property (atomic,readwrite) BOOL isDoubleTouch;
@property (nonatomic, readwrite) BOOL isEraserSelected;
@property (atomic, readwrite)  BOOL isScrollingEnable;
@property (atomic,readwrite)   BOOL isUnEraserSelected;
@property (nonatomic, assign)  BOOL isPushtoMoreScreen;


@property (nonatomic,retain)  UserView *userViewController;;

@property (nonatomic, retain) IBOutlet UITabBar *tabBar;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UIImageView *bgimageView;


@property (atomic, assign)  CGPoint startLocation;

@property (atomic,retain) NSMutableArray *unEraseArray;
@property (nonatomic,assign) int eraserWidth;

//@property (nonatomic, retain)  UIPinchGestureRecognizer *pinchGesture;
//@property (nonatomic, retain)  UITapGestureRecognizer *tapGesture;


@property (nonatomic, readonly)   BOOL isFirstInstrustion;
@property (nonatomic, readonly)   BOOL isPreview;
-(IBAction)eraserSliderAction:(UISlider*)sender;
- (void) hideEraserSlider;
@end
