//
//  FrameCaptionViewController.h
//  MyTravels
//
//  Created by Rahul Kumar Jain on 02/11/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserResizableView.h"
#import "GrowingTextView.h"
#import "AnimateViewHelper.h"
#import "AdWhirlDelegateProtocol.h"
#import "AdWhirlView.h"





@class EditingViewController;
@class CaptionViewController;
@class TextViewController;
@class FrameViewController;

@interface FrameCaptionViewController : UIViewController<UITextFieldDelegate,GrowingTextViewDelegate,UserResizableViewDelegate,UITabBarControllerDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate, UIAlertViewDelegate,AdWhirlDelegate>
{
    IBOutlet UISegmentedControl *segmentCtrl;
    
    UIView *frameView;
    //CaptionView *captionView;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UITextField *textField;
    
    IBOutlet UIView *backView;
    IBOutlet UIImageView *bgimageView;
    IBOutlet UIImageView *frameImageView;
    
    TextViewController *textViewController;
    CaptionViewController *captionViewController;
    EditingViewController *superController;
    FrameViewController *frameViewController;
    
   
    
    GrowingTextView *quoteTextView;
    UserResizableView *quoteResizableView;
    
    UserResizableView *currentlyEditingView;
    UserResizableView *lastEditedView;
    
   
    BOOL isKeyboardOpens;
    BOOL isShowTextController;
    BOOL isSaveEditing;
    
    UIFont *selectedFont;
    NSInteger fontSize;
    
    UIPinchGestureRecognizer *pinchGesture;
    
    BOOL isFrameApply;
    
    float currentScale;
    float lastScale;
    
    NSMutableArray *captionsArray;
    UIBarButtonItem *shareBarButton;
    
 
    AdWhirlView *adView;
}



@property (nonatomic, readwrite) NSInteger fontSize;
@property (nonatomic, retain) UIFont *selectedFont;

@property (nonatomic, retain) UIView *frameView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) IBOutlet UIImageView *bgimageView;

@property (nonatomic, retain)  GrowingTextView *quoteTextView;
@property (nonatomic, retain)  UserResizableView *quoteResizableView;
@property (nonatomic, readwrite) BOOL isKeyboardOpens;

@property (nonatomic, retain) TextViewController *textViewController;
@property (nonatomic, retain) EditingViewController *superController;
@property (nonatomic, retain) CaptionViewController *captionViewController;
@property (nonatomic, retain) FrameViewController *frameViewController;


@property (nonatomic, retain)  UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, assign) BOOL isFrameApply;
@property (nonatomic,assign)  float currentScale;
@property (nonatomic, assign) float lastScale;
@property (atomic, assign)  CGPoint startLocation;

@property (nonatomic, retain) IBOutlet UIImageView *frameImageView;
@property (atomic, readwrite) BOOL isDoubleTouch;
@property (nonatomic,retain) IBOutlet UIView *backView;
@property (nonatomic, readwrite)  BOOL isShowTextController;
@property (nonatomic, retain) NSMutableArray *captionsArray;

- (void) showTextView;

- (void)selectedFontSize:(int)size;
- (void)selectedFont:(NSString*)fontName;
- (void) removeText;
- (void)selectedFontColor:(UIColor*)fontColor;

- (void)applySrttingforTextCaption;
@end
