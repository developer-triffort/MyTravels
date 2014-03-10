//
//  UserResizableView.h
//  UserResizableView
//
//  Created by Stephen Poletto on 12/10/11.
//
//  UserResizableView is a user-resizable, user-repositionable
//  UIView subclass.

#import <Foundation/Foundation.h>

typedef struct UserResizableViewAnchorPoint {
    CGFloat adjustsX;
    CGFloat adjustsY;
    CGFloat adjustsH;
    CGFloat adjustsW;
} UserResizableViewAnchorPoint;

@protocol UserResizableViewDelegate;
@class SPGripViewBorderView;

@interface UserResizableView : UIView <UIGestureRecognizerDelegate>{
    SPGripViewBorderView *borderView;
    UIView *contentView;
    CGPoint touchStart;
    CGFloat minWidth;
    CGFloat minHeight;
    
    // Used to determine which components of the bounds we'll be modifying, based upon where the user's touch started.
    UserResizableViewAnchorPoint anchorPoint;
    
    UITapGestureRecognizer *tapGesture;
    
    id <UserResizableViewDelegate> delegate;
}

@property (nonatomic, assign) id <UserResizableViewDelegate> delegate;
@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;

// Will be retained as a subview.
@property (nonatomic, assign) UIView *contentView;

// Default is 48.0 for each.
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

// Defaults to YES. Disables the user from dragging the view outside the parent view's bounds.
@property (nonatomic) BOOL preventsPositionOutsideSuperview;

- (void)showEditing;
- (void)hideEditingHandles;

@end

@protocol UserResizableViewDelegate <NSObject>

@optional

// Called when the resizable view receives touchesBegan: and activates the editing handles.
- (void)userResizableViewDidBeginEditing:(UserResizableView *)userResizableView;

// Called when the resizable view receives touchesEnded: or touchesCancelled:
- (void)userResizableViewDidEndEditing:(UserResizableView *)userResizableView;

- (void) showKeyBoard;

@end
