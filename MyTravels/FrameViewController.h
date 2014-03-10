//
//  FrameViewController.h
//  MyTravels
//
//  Created by Rahul Jain on 01/12/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrameCaptionViewController;
#import "FrameView.h"

@interface FrameViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *frameView;
    IBOutlet UIButton *closeButton;
    
    FrameCaptionViewController *superController;
   
    
    FrameView *appliedFrameView;

}

@property (nonatomic, retain)  FrameCaptionViewController *superController;
@property (nonatomic, retain)  FrameView *appliedFrameView;

@end
