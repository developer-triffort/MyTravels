//
//  ColorPickerController.h
//  Quotify
//
//  Created by Rahul Jain on 18/10/12.
//  Copyright (c) 2012 rahul kuamr jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILSaturationBrightnessPickerView.h"
#import "ILHuePickerView.h"

@class EffectsViewController;  
@class FontViewController;

@interface ColorPickerController : UIViewController<ILSaturationBrightnessPickerViewDelegate> {

    EffectsViewController *effectsViewController;
    FontViewController *fontViewController;
    
    IBOutlet UIView *colorChip;
    IBOutlet ILSaturationBrightnessPickerView *colorPicker;
    IBOutlet ILHuePickerView *huePicker;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *scrollBGView;
}

@property (nonatomic, retain) EffectsViewController *effectsViewController;
@property (nonatomic, retain) FontViewController *fontViewController;

@end
