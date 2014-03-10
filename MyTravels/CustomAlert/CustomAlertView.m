//
//  CustomAlertView.m
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomAlertView.h"
#import "UIView-AlertAnimations.h"
#import <QuartzCore/QuartzCore.h>
#import "EditingViewController.h"


@interface CustomAlertView()


- (IBAction)done:(id)sender;
- (void)alertDidFadeOut;

@end

@implementation CustomAlertView

@synthesize alertView;
@synthesize backgroundView;
@synthesize inputField;
@synthesize delegate;
@synthesize previewView;
@synthesize editController;

#pragma mark -
#pragma mark IBActions

- (IBAction)show
{
    // Retaining self is odd, but we do it to make this "fire and forget"
    [self retain];
    
    // We need to add it to the window, which we can get from the delegate
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    [window addSubview:self.view];
    
    // Make sure the alert covers the whole window
    self.view.frame = window.frame;
    self.view.center = window.center;
 
    alertView.layer.cornerRadius = 10;
    alertView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    alertView.layer.borderWidth = 5.0;
    
    // "Pop in" animation for alert
    [alertView doPopInAnimationWithDelegate:self];
    
    // "Fade in" animation for background
    [backgroundView doFadeInAnimation];
    
}

- (IBAction)dismiss:(id)sender
{
    [inputField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    self.view.alpha = 0.0;
    [UIView commitAnimations];
    
    [self performSelector:@selector(alertDidFadeOut) withObject:nil afterDelay:0.5];
    
    if (sender == self || [sender tag] == CustomAlertViewButtonTagOk)
        [delegate CustomAlertView:self wasDismissedWithValue:inputField.text];
    else
    {
        if ([delegate respondsToSelector:@selector(customAlertViewWasCancelled:)])
            [delegate customAlertViewWasCancelled:self];
    }
}


#pragma mark -
- (void)viewDidUnload 
{
    [super viewDidUnload];
    self.alertView = nil;
    self.backgroundView = nil;
    self.inputField = nil;
    
}
- (void)dealloc 
{
    [alertView release];
    [backgroundView release];
    [inputField release];
    [super dealloc];
}
#pragma mark -
#pragma mark Private Methods

- (void)alertDidFadeOut
{    
    [self.view removeFromSuperview];
    [self autorelease];
}
#pragma mark -
#pragma mark CAAnimation Delegate Methods

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    [self.inputField becomeFirstResponder];
}

-(IBAction)done:(id)sender{
    
    [self dismiss:nil];
  
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Do you want to apply text,frame or caption on Image?" message:@"Press yes or no" delegate:editController cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertview show];
    alertview.tag = 1;
    [alertview release];

}


@end
