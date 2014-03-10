//
//  FrameView.h
//  MyTravels
//
//  Created by Rahul Jain on 07/12/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrameView : UIViewController<UIGestureRecognizerDelegate>
{
    CGPoint startLocation;
    
    BOOL isDoubleTouch;
    
    CGFloat currentScale;
    CGFloat lastScale;
    CGFloat lastRotation;
    
    UIPinchGestureRecognizer *pinchGesture;
    UIRotationGestureRecognizer *rotateGesture;
}
@property (nonatomic, assign) CGPoint startLocation;

@property (nonatomic, retain) UIImageView *frameImageView;
@property (nonatomic, retain)  UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, retain) UIRotationGestureRecognizer *rotateGesture;
@end
