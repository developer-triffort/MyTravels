//
//  ColorPickerController.m
//  Quotify
//
//  Created by Rahul Jain on 18/10/12.
//  Copyright (c) 2012 rahul kuamr jain. All rights reserved.
//
#import "ColorPickerController.h"
#import "FontViewController.h"
//#import "EffectsViewController.h"

@implementation ColorPickerController

@synthesize fontViewController, effectsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - ILSaturationBrightnessPickerDelegate implementation

- (void)touchStartForPicker:(ILSaturationBrightnessPickerView *)picker {

    [scrollView setScrollEnabled:FALSE];
    
}

- (void)touchEndForPicker:(ILSaturationBrightnessPickerView *)picker {
    
    [scrollView setScrollEnabled:TRUE];
    
}

-(void)colorPicked:(UIColor *)newColor forPicker:(ILSaturationBrightnessPickerView *)picker
{
    colorChip.backgroundColor = newColor;
    
    if (effectsViewController) {
    
        [effectsViewController selectedBackgroundColor:newColor];
    }
    else if (fontViewController)
        [fontViewController selectedBackgroundColor:newColor];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    self.contentSizeForViewInPopover = CGSizeMake(320, 440);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollView.contentSize = scrollBGView.frame.size;
    
    self.title = @"Color Picker";
    
    // Build a random color to show off setting the color on the pickers
    
    UIColor *c=[UIColor colorWithRed:(arc4random()%100)/100.0f 
                               green:(arc4random()%100)/100.0f
                                blue:(arc4random()%100)/100.0f
                               alpha:1.0];
    
    colorChip.backgroundColor=c;
    colorPicker.color=c;
    huePicker.color=c;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
//            return YES;
//        }
        
        return YES;
    } 
    
    else {
        
        if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            return NO;
        }
        
        return NO;
    }
    
    return NO;
}

@end
