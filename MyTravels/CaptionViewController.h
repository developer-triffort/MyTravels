//
//  CaptionViewController.h
//  MyTravels
//
//  Created by Rahul Jain on 01/12/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrameCaptionViewController;

@interface CaptionViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *captionView;
    IBOutlet UIButton *closeButton;
    
    FrameCaptionViewController *superController;
}

@property (nonatomic, retain) FrameCaptionViewController *superController;

@end
