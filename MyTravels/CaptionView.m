//
//  frameview.m
//  My Greetings
//
//  Created by Rahul Kumar jain on 05/12/12
//  Copyright 2011 triffort. All rights reserved.
//

#import "CaptionView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "FrameCaptionViewController.h"
#import "FontViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CaptionView

//static float lastScale;

@synthesize captionImageView;
@synthesize startLocation;
@synthesize isCaptionMoveEnable,isDoubleTouch;
@synthesize ioAccView;

@synthesize pinchGesture;
@synthesize superController;
@synthesize rotateGesture;
@synthesize currentScale,lastScale,lastRotation;
@synthesize tapGesture;
@synthesize tapCount;
@synthesize textView;

- (BOOL)hasFourInchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height > 500.0);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    captionImageView = [[UIImageView alloc] init];
    
    self.view.multipleTouchEnabled = YES;
    self.view.userInteractionEnabled = YES;
    //self.view.backgroundColor = [UIColor greenColor];
     tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesture:)];
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
     
    pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGuestureAction:)];
    [self.view addGestureRecognizer:pinchGesture];
    pinchGesture.delegate = self;
    
    rotateGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateBackView:)];
    [self.view addGestureRecognizer:rotateGesture];
    rotateGesture.delegate = self;
   
    if(!textView)
        [self addText];
}
-(void)resignTextView
{
	[textView resignFirstResponder];
}

- (void) deletePressed:(id)sender {
    
    if (containerView) {
        
        [containerView removeFromSuperview];
    }
}


-(void)addText{
    
    AppDelegate *appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    captionImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    captionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat textViewHeght = captionImageView.frame.size.height - 100;
    CGFloat textViewWidth = captionImageView.frame.size.width -100;
    
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(captionImageView.center.x- textViewWidth/2, captionImageView.center.y-textViewHeght/2, textViewWidth+20,textViewHeght+80)] ;
      
    textView.superController = self;
    
   
   
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 3;
	textView.returnKeyType = UIReturnKeyDefault; //just as an example
    textView.font = [UIFont fontWithName:appDel.captionFontName size:appDel.captionFontSize]; // Futura
    textView.delegate = self;
    
    textView.textAlignment = NSTextAlignmentCenter;
    [self setContentEdgeInsetTexview:textView];

    textView.textColor = appDel.captionFontColo;
    textView.backgroundColor = [UIColor clearColor];
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  
   
    [self.view addGestureRecognizer:tapGesture];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    
    //textView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:captionImageView];
    
   
    [captionImageView addSubview:textView];
    
    [textView becomeFirstResponder];
    
       
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];	
	
}



//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = 10;//self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	//containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = 50;//self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	//containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
    [imageArray addObject:containerView];
    
     
}

- (void) setContentEdgeInsetTexview:(HPGrowingTextView *)growingTextView
{
    int numLines = growingTextView.activeTextview.contentSize.height / growingTextView.font.lineHeight;
    CGFloat top = 0;
    if(numLines < 4)
    {
        top = (growingTextView.frame.size.height - growingTextView.activeTextview.contentSize.height)/2;
        growingTextView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
    }
    else
    {
        growingTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(-5,-5, 0, 0);
        growingTextView.contentInset = UIEdgeInsetsMake(-5, -5, 0, 0);
    }

}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    // enable resizing comment metthod -(void)resizeTextView:(NSInteger)newSizeH in HPGrowingTextView.m
    NSLog(@"height is %f",textView.frame.size.height);

    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = growingTextView.frame;
    if(CGRectContainsRect(captionImageView.frame, r))
    {
        r.size.height -= diff;
        growingTextView.frame = r;
    }
    
     
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    [self setContentEdgeInsetTexview:growingTextView];
    
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self setContentEdgeInsetTexview:growingTextView];
    return YES;
}
- (CGFloat ) fixedMaxHeightGrowingTextView
{
    NSLog(@"frame hieight %f",textView.frame.size.height);
    return textView.frame.size.height;
}
#pragma mark - Gesture

-(void) singleTap
{
    if(tapCount!=0 && !isShortMove)
        [textView becomeFirstResponder];
    
    tapCount = 0;
    
}
- (void) doubleTap
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Do you want to change font size, color or type?" message:@"\"Yes\" for change Otherwise \"No\"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertView show];
    [alertView release];
    tapCount = 0;
}

- (void)singleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    tapCount++;
    
    switch (tapCount)
    {
        case 1:
            [self performSelector:@selector(singleTap) withObject: nil afterDelay:.5];
            break;
            
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
            [self performSelector:@selector(doubleTap) withObject: nil];
            
            break;
            
        default:
            break;
    }
    
    if (tapCount>2) tapCount=0;
    
}


-(void)pinchGuestureAction:(UIPinchGestureRecognizer*)gestureRecognizer
{
    currentScale += [gestureRecognizer scale] - lastScale;
    lastScale = [gestureRecognizer scale];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        lastScale = 1.0f;
        
    }
    if(currentScale >= 0.3f)
    {
        
        CGAffineTransform oldTransform = CGAffineTransformIdentity;
        CGAffineTransform newTransform = CGAffineTransformScale(oldTransform,currentScale,currentScale);
        
        [captionImageView setTransform:newTransform];
        NSLog(@"pinch %f",currentScale);
        
    }
}

-(void)rotateBackView:(id)sender
{
	if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		lastRotation = 0.0;
		return;
	}
	
	CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
	
	CGAffineTransform oldTransform = captionImageView.transform;
	CGAffineTransform newTransform = CGAffineTransformRotate(oldTransform,rotation);
	
	[captionImageView setTransform:newTransform];
	
	lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    
	
}

- (void) drawLayerForView: (UIView*)captionView
{
    captionView.layer.borderColor = [UIColor greenColor].CGColor;
    captionView.layer.borderWidth = 2;
}

- (void)hideLayer: (UIView*)captionView
{
    if(CGRectContainsRect(self.view.frame, captionView.frame))
    {
        captionView.layer.borderColor = [UIColor clearColor].CGColor;
        captionView.layer.borderWidth = 0;
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self.view];
        
    startLocation = pt;
    isDoubleTouch = NO;
    isShortMove = NO;
 
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
        
    UITouch *touch = [[event allTouches] anyObject];
    
    if([[event allTouches] count] == 2)
        isDoubleTouch = YES;
       
    if(isCaptionMoveEnable && !isDoubleTouch)//(isDoubleTouch == YES && touch.phase == UITouchPhaseMoved)
    {
        isShortMove = YES;
        
        CGPoint newLocation = [touch locationInView:self.view];
        int previousX = startLocation.x;
        int previousY = startLocation.y;
        
        int currentX = newLocation.x;
        int currentY = newLocation.y;
        
        int movedX, movedY;
        movedX = currentX-previousX;
        movedY = currentY - previousY;
        
        CGPoint imageCenter = self.view.center;
        self.view.center = CGPointMake(imageCenter.x+movedX,imageCenter.y+movedY);
        
    }
} 


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    isShortMove = NO;
    
}


- (void)viewDidUnload
{ 
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark - Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        FontViewController *fontViewController= nil;
        
        if([self hasFourInchDisplay])
            fontViewController = [superController.storyboard instantiateViewControllerWithIdentifier:@"FontDetailController_iPhone5"];
        else
            fontViewController = [superController.storyboard instantiateViewControllerWithIdentifier:@"FontDetailController"];
        
        fontViewController.textView = textView;
        fontViewController.isCaptioning = YES;
        fontViewController.superController = superController;
        [superController.navigationController pushViewController:fontViewController animated:YES];
        
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
