//
//  TextViewController.h
//  MyTravels
//
//  Created by Triffort on 23/11/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontViewController.h"
@class FrameCaptionViewController;

@interface TextViewController : UIViewController
{
    FrameCaptionViewController *superController;
    UIBarButtonItem *addTextButton;
}
@property (nonatomic, retain) FrameCaptionViewController *superController;

-(IBAction)showText :(UIBarButtonItem *)sender;
- (IBAction)showFontName;
- (IBAction)removeText : (UIBarButtonItem *)sender;
@end
