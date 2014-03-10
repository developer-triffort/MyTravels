//
//  CustomAlertView.h
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditingViewController;


enum 
{
    CustomAlertViewButtonTagOk = 1000,
    CustomAlertViewButtonTagCancel
};

@class CustomAlertView;

@protocol CustomAlertViewDelegate
@required
- (void) CustomAlertView:(CustomAlertView *)alert wasDismissedWithValue:(NSString *)value;

@optional
- (void) customAlertViewWasCancelled:(CustomAlertView *)alert;
@end


@interface CustomAlertView : UIViewController 
{
    UIView                                  *alertView;
    UIView                                  *backgroundView;
    UITextView                              *inputField;
    
     IBOutlet UIImageView *previewView;
    
    id<NSObject, CustomAlertViewDelegate>   delegate;
    
    EditingViewController *editController;
}

@property (nonatomic, retain) IBOutlet  UIView *alertView;
@property (nonatomic, retain) IBOutlet  UIView *backgroundView; 
@property (nonatomic, retain) IBOutlet  UITextView *inputField;
@property (atomic, retain)  IBOutlet UIImageView *previewView;

@property (nonatomic, assign) IBOutlet id<CustomAlertViewDelegate, NSObject> delegate;
@property (nonatomic, retain) EditingViewController *editController;

- (IBAction)show;
- (IBAction)dismiss:(id)sender;




@end
