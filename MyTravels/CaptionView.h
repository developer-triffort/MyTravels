//
//  frameview.h
//  My Greetings
//
//  Created by Rahul Kumar Jain on 05/12/12.
//  Copyright 2011 triffort. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@class FrameCaptionViewController;
@interface CaptionView : UIViewController<UIGestureRecognizerDelegate,UIScrollViewDelegate, HPGrowingTextViewDelegate,UIAlertViewDelegate> {
    
    UIView *ioAccView; // Keyboard input accesssory view
    UIView *containerView;
    HPGrowingTextView *textView;
    
  
    
    UIImageView *captionImageView;
    
    CGPoint lastPoint;
    CGPoint startLocation;

    BOOL isDoubleTouch;
    BOOL isCaptionMoveEnable; // controll caption movement with single fingure
    BOOL isShortMove;   // Contoll text view become first responder after short move
    
    UIPinchGestureRecognizer *pinchGesture;
    
    FrameCaptionViewController *superController;
    
    UIView *deleteview;
    
    
	CGFloat lastScale;
	CGFloat lastRotation;
    CGFloat currentScale;
    
    
    CGAffineTransform transform;
    
    CGFloat fltRotatedAngle;
    
    
    BOOL objectAlertShown;
    
    NSMutableArray *undoRedoStoreDataArray;
    
    NSMutableArray *imageArray;
    NSMutableArray *reverseImageArray;
    
    UIImageView *selectedImageView;
    
    UIImageView *image;
    NSString *frameName;
    
    int tapCount;
    
    UIRotationGestureRecognizer *rotateGesture;//for rotate the image
    //UIPinchGestureRecognizer *pinchGesture;
    CGAffineTransform currentTransform;
    CGPoint tPoint;
    
}


@property (nonatomic, assign) CGFloat lastScale;
@property (nonatomic, assign) CGFloat lastRotation;
@property (nonatomic, assign) CGFloat currentScale;

@property (nonatomic, assign) CGPoint startLocation;
@property (atomic, retain)  UIImageView *captionImageView;
@property (atomic, assign) BOOL isDoubleTouch;
@property (nonatomic, retain)  UIView *ioAccView;

@property (nonatomic, retain)  UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, retain) UIRotationGestureRecognizer *rotateGesture;
@property (nonatomic, retain) FrameCaptionViewController *superController;
@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;
@property (atomic, assign) int tapCount;
@property (atomic, retain)  HPGrowingTextView *textView;

@property (nonatomic, readwrite) BOOL isCaptionMoveEnable;
- (void)resignTextView;
- (void) addText;
- (void)hideLayer: (UIView*)captionView;
- (CGFloat ) fixedMaxHeightGrowingTextView;
@end
