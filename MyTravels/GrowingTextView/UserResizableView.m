//
//  UserResizableView.m
//  UserResizableView
//
//  Created by Stephen Poletto on 12/10/11.
//

#import "UserResizableView.h"

/* Let's inset everything that's drawn (the handles and the content view)
   so that users can trigger a resize from a few pixels outside of
   what they actually see as the bounding box. */
#define kUserResizableViewGlobalInset 5.0

#define kUserResizableViewDefaultMinWidth 70.0
#define kUserResizableViewDefaultMinHeight 48.0
#define kUserResizableViewInteractiveBorderSize 10.0

static UserResizableViewAnchorPoint UserResizableViewNoResizeAnchorPoint = { 0.0, 0.0, 0.0, 0.0 };
static UserResizableViewAnchorPoint UserResizableViewUpperLeftAnchorPoint = { 1.0, 1.0, -1.0, 1.0 };
static UserResizableViewAnchorPoint UserResizableViewMiddleLeftAnchorPoint = { 1.0, 0.0, 0.0, 1.0 };
static UserResizableViewAnchorPoint UserResizableViewLowerLeftAnchorPoint = { 1.0, 0.0, 1.0, 1.0 };
static UserResizableViewAnchorPoint UserResizableViewUpperMiddleAnchorPoint = { 0.0, 1.0, -1.0, 0.0 };
static UserResizableViewAnchorPoint UserResizableViewUpperRightAnchorPoint = { 0.0, 1.0, -1.0, -1.0 };
static UserResizableViewAnchorPoint UserResizableViewMiddleRightAnchorPoint = { 0.0, 0.0, 0.0, -1.0 };
static UserResizableViewAnchorPoint UserResizableViewLowerRightAnchorPoint = { 0.0, 0.0, 1.0, -1.0 };
static UserResizableViewAnchorPoint UserResizableViewLowerMiddleAnchorPoint = { 0.0, 0.0, 1.0, 0.0 };

@interface SPGripViewBorderView : UIView
@end

@implementation SPGripViewBorderView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Clear background to ensure the content view shows through.
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // (1) Draw the bounding box.
    CGContextSetLineWidth(context, 1.0);
    UIColor *lineColor = [UIColor colorWithRed:43.0/255.0 green:131.0/255.0 blue:44.0/255.0 alpha:1.0];
    
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextAddRect(context, CGRectInset(self.bounds, kUserResizableViewInteractiveBorderSize/2, kUserResizableViewInteractiveBorderSize/2));
    CGContextStrokePath(context);
    
    // (2) Calculate the bounding boxes for each of the anchor points.
    CGRect upperLeft = CGRectMake(0.0, 0.0, kUserResizableViewInteractiveBorderSize, kUserResizableViewInteractiveBorderSize);
    CGRect upperRight = CGRectMake(self.bounds.size.width - kUserResizableViewInteractiveBorderSize, 0.0, kUserResizableViewInteractiveBorderSize, kUserResizableViewInteractiveBorderSize);
    CGRect lowerRight = CGRectMake(self.bounds.size.width - kUserResizableViewInteractiveBorderSize, self.bounds.size.height - kUserResizableViewInteractiveBorderSize, kUserResizableViewInteractiveBorderSize, kUserResizableViewInteractiveBorderSize);
    CGRect lowerLeft = CGRectMake(0.0, self.bounds.size.height - kUserResizableViewInteractiveBorderSize, kUserResizableViewInteractiveBorderSize, kUserResizableViewInteractiveBorderSize);
    CGRect upperMiddle = CGRectMake((self.bounds.size.width - kUserResizableViewInteractiveBorderSize)/2, 0.0, kUserResizableViewInteractiveBorderSize, kUserResizableViewInteractiveBorderSize);
    CGRect lowerMiddle = CGRectMake((self.bounds.size.width - kUserResizableViewInteractiveBorderSize)/2, self.bounds.size.height - kUserResizableViewInteractiveBorderSize, kUserResizableViewInteractiveBorderSize, kUserResizableViewInteractiveBorderSize);
    CGRect middleLeft = CGRectMake(0.0, (self.bounds.size.height - kUserResizableViewInteractiveBorderSize)/2, kUserResizableViewInteractiveBorderSize, kUserResizableViewInteractiveBorderSize);
    CGRect middleRight = CGRectMake(self.bounds.size.width - kUserResizableViewInteractiveBorderSize, (self.bounds.size.height - kUserResizableViewInteractiveBorderSize)/2, kUserResizableViewInteractiveBorderSize, kUserResizableViewInteractiveBorderSize);
    
    // (3) Create the gradient to paint the anchor points.
    CGFloat colors [] = { 
        0.4, 0.8, 1.0, 1.0, 
        0.0, 1.0, 0.0, 1.0
    };
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    // (4) Set up the stroke for drawing the border of each of the anchor points.
    CGContextSetLineWidth(context, 1);
    CGContextSetShadow(context, CGSizeMake(0.5, 0.5), 1);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    
    // (5) Fill each anchor point using the gradient, then stroke the border.
    CGRect allPoints[8] = { upperLeft, upperRight, lowerRight, lowerLeft, upperMiddle, lowerMiddle, middleLeft, middleRight };
    for (NSInteger i = 0; i < 8; i++) {
        CGRect currPoint = allPoints[i];
        CGContextSaveGState(context);
        CGContextAddEllipseInRect(context, currPoint);
        CGContextClip(context);
        CGPoint startPoint = CGPointMake(CGRectGetMidX(currPoint), CGRectGetMinY(currPoint));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(currPoint), CGRectGetMaxY(currPoint));
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(context);
        CGContextStrokeEllipseInRect(context, CGRectInset(currPoint, 1, 1));
    }
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
}

@end 

@implementation UserResizableView

@synthesize contentView, minWidth, minHeight, preventsPositionOutsideSuperview, delegate, tapGesture;

- (void)setupDefaultAttributes {
    borderView = [[SPGripViewBorderView alloc] initWithFrame:CGRectInset(self.bounds, kUserResizableViewGlobalInset, kUserResizableViewGlobalInset)];
    [borderView setHidden:YES];
    [self addSubview:borderView];
    self.minWidth = kUserResizableViewDefaultMinWidth;
    self.minHeight = kUserResizableViewDefaultMinHeight;
    self.preventsPositionOutsideSuperview = YES;
    
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    [borderView addGestureRecognizer:tapGesture];
    tapGesture.numberOfTapsRequired = 2;
    tapGesture.delegate = self;
}
-(void) tapGestureAction: (UITapGestureRecognizer *)gestureRecognizer
{    
    [borderView setHidden:YES];
    [self.delegate showKeyBoard];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setupDefaultAttributes];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setupDefaultAttributes];
    }
    return self;
}

- (void)setContentView:(UIView *)newContentView {
    [contentView removeFromSuperview];
    contentView = newContentView;
    contentView.frame = CGRectInset(self.bounds, kUserResizableViewGlobalInset + kUserResizableViewInteractiveBorderSize/2, kUserResizableViewGlobalInset + kUserResizableViewInteractiveBorderSize/2);
    [self addSubview:contentView];
    
    // Ensure the border view is always on top by removing it and adding it to the end of the subview list.
    [borderView removeFromSuperview];
    [self addSubview:borderView];
}

- (void)setFrame:(CGRect)newFrame {
    [super setFrame:newFrame];
    contentView.frame = CGRectInset(self.bounds, kUserResizableViewGlobalInset + kUserResizableViewInteractiveBorderSize/2, kUserResizableViewGlobalInset + kUserResizableViewInteractiveBorderSize/2);
    borderView.frame = CGRectInset(self.bounds, kUserResizableViewGlobalInset, kUserResizableViewGlobalInset);
    [borderView setNeedsDisplay];
}

static CGFloat SPDistanceBetweenTwoPoints(CGPoint point1, CGPoint point2) {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy);
};

typedef struct CGPointUserResizableViewAnchorPointPair {
    CGPoint point;
    UserResizableViewAnchorPoint anchorPoint;
} CGPointUserResizableViewAnchorPointPair;

- (UserResizableViewAnchorPoint)anchorPointForTouchLocation:(CGPoint)touchPoint {
    // (1) Calculate the positions of each of the anchor points.
    CGPointUserResizableViewAnchorPointPair upperLeft = { CGPointMake(0.0, 0.0), UserResizableViewUpperLeftAnchorPoint };
    CGPointUserResizableViewAnchorPointPair upperMiddle = { CGPointMake(self.bounds.size.width/2, 0.0), UserResizableViewUpperMiddleAnchorPoint };
    CGPointUserResizableViewAnchorPointPair upperRight = { CGPointMake(self.bounds.size.width, 0.0), UserResizableViewUpperRightAnchorPoint };
    CGPointUserResizableViewAnchorPointPair middleRight = { CGPointMake(self.bounds.size.width, self.bounds.size.height/2), UserResizableViewMiddleRightAnchorPoint };
    CGPointUserResizableViewAnchorPointPair lowerRight = { CGPointMake(self.bounds.size.width, self.bounds.size.height), UserResizableViewLowerRightAnchorPoint };
    CGPointUserResizableViewAnchorPointPair lowerMiddle = { CGPointMake(self.bounds.size.width/2, self.bounds.size.height), UserResizableViewLowerMiddleAnchorPoint };
    CGPointUserResizableViewAnchorPointPair lowerLeft = { CGPointMake(0, self.bounds.size.height), UserResizableViewLowerLeftAnchorPoint };
    CGPointUserResizableViewAnchorPointPair middleLeft = { CGPointMake(0, self.bounds.size.height/2), UserResizableViewMiddleLeftAnchorPoint };
    CGPointUserResizableViewAnchorPointPair centerPoint = { CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2), UserResizableViewNoResizeAnchorPoint };
    
    // (2) Iterate over each of the anchor points and find the one closest to the user's touch.
    CGPointUserResizableViewAnchorPointPair allPoints[9] = { upperLeft, upperRight, lowerRight, lowerLeft, upperMiddle, lowerMiddle, middleLeft, middleRight, centerPoint };
    CGFloat smallestDistance = MAXFLOAT; CGPointUserResizableViewAnchorPointPair closestPoint = centerPoint;
    for (NSInteger i = 0; i < 9; i++) {
        CGFloat distance = SPDistanceBetweenTwoPoints(touchPoint, allPoints[i].point);
        if (distance < smallestDistance) { 
            closestPoint = allPoints[i];
            smallestDistance = distance;
        }
    }
    return closestPoint.anchorPoint;
}

- (BOOL)isResizing {
    return (anchorPoint.adjustsH || anchorPoint.adjustsW || anchorPoint.adjustsX || anchorPoint.adjustsY);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've begun our editing session.
    if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidBeginEditing:)]) {
        [self.delegate userResizableViewDidBeginEditing:self];
    }
    
    [borderView setHidden:NO];
    touchStart = [[touches anyObject] locationInView:self];
    anchorPoint = [self anchorPointForTouchLocation:touchStart];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've ended our editing session.
    if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidEndEditing:)]) {
        [self.delegate userResizableViewDidEndEditing:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // Notify the delegate we've ended our editing session.
    if (self.delegate && [self.delegate respondsToSelector:@selector(userResizableViewDidEndEditing:)]) {
        [self.delegate userResizableViewDidEndEditing:self];
    }
}

- (void)showEditing {
    
    [borderView setHidden:NO];
}

- (void)hideEditingHandles {
    [borderView setHidden:YES];
}

- (void)resizeUsingTouchLocation:(CGPoint)touchPoint {
    // (1) Calculate the deltas using the current anchor point.
    CGFloat deltaW = anchorPoint.adjustsW * (touchStart.x - touchPoint.x);
    CGFloat deltaX = anchorPoint.adjustsX * (-1.0 * deltaW);
    CGFloat deltaH = anchorPoint.adjustsH * (touchPoint.y - touchStart.y);
    CGFloat deltaY = anchorPoint.adjustsY * (-1.0 * deltaH);
        
    // (2) Update the 'touchStart' reference point if needed.
    if (anchorPoint.adjustsW < 0) {
        touchStart.x = touchPoint.x;
    }
    if (anchorPoint.adjustsH > 0) {
        touchStart.y = touchPoint.y;
    }
    
    // (3) Calculate the new frame.
    CGFloat newX = self.frame.origin.x + deltaX;
    CGFloat newY = self.frame.origin.y + deltaY;
    CGFloat newWidth = self.frame.size.width + deltaW;
    CGFloat newHeight = self.frame.size.height + deltaH;
    
    // (4) If the new frame is too small, cancel the changes.
    if (newWidth < self.minWidth) {
        newWidth = self.frame.size.width;
        newX = self.frame.origin.x;
    }
    if (newHeight < self.minHeight) {
        newHeight = self.frame.size.height;
        newY = self.frame.origin.y;
    }
    
    self.frame = CGRectMake(newX, newY, newWidth, newHeight);
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint {
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x, self.center.y + touchPoint.y - touchStart.y);
    if (self.preventsPositionOutsideSuperview) {
        // Ensure the translation won't cause the view to move offscreen.
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        if (newCenter.x > self.superview.bounds.size.width - midPointX) {
            newCenter.x = self.superview.bounds.size.width - midPointX;
        }
        if (newCenter.x < midPointX) {
            newCenter.x = midPointX;
        }
        CGFloat midPointY = CGRectGetMidY(self.bounds);
        if (newCenter.y > self.superview.bounds.size.height - midPointY) {
            newCenter.y = self.superview.bounds.size.height - midPointY;
        }
        if (newCenter.y < midPointY) {
            newCenter.y = midPointY;
        }
    }
    self.center = newCenter;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if ([self isResizing]) {
        [self resizeUsingTouchLocation:touchPoint];
    } else {
        [self translateUsingTouchLocation:touchPoint];
    }
}

- (void)dealloc {
    [contentView removeFromSuperview];
    [borderView release];
    [super dealloc];
}

@end
