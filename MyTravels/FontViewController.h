//
//  FontViewController.h
//  Quotify
//
//  Created by Rahul Jain on 18/10/12.
//  Copyright (c) 2012 rahul kuamr jain. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ColorPickerController.h"
#import "HPGrowingTextView.h"
@class FrameCaptionViewController;

@interface FontViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate> {
    
   
        
    IBOutlet UILabel *sampleText;
    IBOutlet UITableView *fontTableView;
    IBOutlet UIPickerView *fontPicker;
    
    UIPopoverController *colorPopover;
    UIColor *currentColor;
    
    int red;
    int green;
    int blue;
    
    UIView *colorView;
    
    UIFont *selectedFont;
    UIStepper *stepper;
    
    NSString *fontSize;
    NSString *fontName;
    
    NSMutableArray *fontArray;
    UITableViewCell *tableCell;
    
    HPGrowingTextView *textView;
    
    FrameCaptionViewController *superController;
    
    BOOL isCaptioning;// check for flow caption
    
    
}

@property (nonatomic, retain) UILabel *sampleText;
@property (nonatomic, retain) UIColor *currentColor;
@property (nonatomic, retain) UIFont *selectedFont;
@property (nonatomic, retain) UIView *colorView;
@property (nonatomic, retain) UIStepper *stepper;
@property (nonatomic, retain) NSString *fontSize;
@property (nonatomic, retain) NSString *fontName;
@property (nonatomic, retain) FrameCaptionViewController *superController;
@property (nonatomic, retain)  HPGrowingTextView *textView;

@property (nonatomic, retain)   NSMutableArray *fontArray;
@property (nonatomic, assign) BOOL isCaptioning;

- (void)selectedBackgroundColor:(UIColor*)color;

@end
