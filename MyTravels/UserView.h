//
//  UserImageView.h
//  MyTravels
//
//  Created by Rahul Jain on 18/10/12.
//  Copyright (c) 2012 rahul kuamr jain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditingViewController;


@interface UserView : UIViewController <UIGestureRecognizerDelegate>{
    
    UIImageView *imageView;
    
    BOOL isDoubleTouch;
    
    UIPinchGestureRecognizer *pinchGesture;
    UIRotationGestureRecognizer *rotateGesture;
    
    EditingViewController *editController;
    
    CGPoint startLocation;
    CGPoint lastPoint;
    CGPoint currentPoint;
    
    float currentScale;
    float lastScale;
    float lastRotation;
}

@property (nonatomic, assign) UIImageView *imageView;   // userIneraction Imageview

@property (atomic, readwrite) BOOL isDoubleTouch;

@property (nonatomic, retain) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, retain) UIRotationGestureRecognizer *rotateGesture;

@property (nonatomic, retain) EditingViewController *editController;
@property (atomic, assign)  CGPoint startLocation;
@property (atomic, assign)  CGPoint lastPoint;


@property (nonatomic,assign)  float currentScale;
@property (nonatomic, assign) float lastScale;
@property (nonatomic, assign) float lastRotation;

- (id)initWithFrame:(CGRect)frame;
@end
