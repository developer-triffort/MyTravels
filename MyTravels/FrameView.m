//
//  FrameView.m
//  MyTravels
//
//  Created by Rahul Jain on 07/12/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import "FrameView.h"

@interface FrameView ()

@end

@implementation FrameView
@synthesize frameImageView;
@synthesize pinchGesture;
@synthesize rotateGesture;
@synthesize startLocation;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    frameImageView = [[UIImageView alloc]init];
    
//    pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGuestureAction:)];
//    [self.view addGestureRecognizer:pinchGesture];
//    pinchGesture.delegate = self;
//
//    rotateGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateBackView:)];
//    [self.view addGestureRecognizer:rotateGesture];
//    rotateGesture.delegate = self;

	// Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    frameImageView.frame = self.view.frame;
    [self.view addSubview:frameImageView];
    frameImageView.contentMode = UIViewContentModeScaleAspectFit;
   

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)rotateBackView:(id)sender
{
	if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		lastRotation = 0.0;
		return;
	}
	
	CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
	
	CGAffineTransform oldTransform = [(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformRotate(oldTransform,rotation);
	
	[self.view setTransform:newTransform];
	
	lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    
	
}
-(void)pinchGuestureAction:(UIPinchGestureRecognizer*)gestureRecognizer
{
    currentScale += [gestureRecognizer scale] - lastScale;
    lastScale = [gestureRecognizer scale];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        lastScale = 1.0f;
        
    }
    if(currentScale >= 0.5f)
    {
            CGAffineTransform oldTransform = CGAffineTransformIdentity;
            CGAffineTransform newTransform = CGAffineTransformScale(oldTransform,currentScale,currentScale);
            
            [frameImageView setTransform:newTransform];
            NSLog(@"pinch %f",currentScale);
        }
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
//    CGPoint pt = [[touches anyObject] locationInView:frameImageView];
//    UITouch *touch = [[event allTouches] anyObject];
//    startLocation = pt;
//    if([[event allTouches] count] == 2 && touch.phase == UITouchPhaseBegan)
//    {
//        isDoubleTouch = YES;
//        NSLog(@"rouch began cod x =%f and cod y= %f",self.view.center.x,self.view.center.y);
//        return;
//    }
//    
//    isDoubleTouch = NO;
        
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [[event allTouches] anyObject];
//    
//    //CGPoint touchLocation = [touch locationInView:frameImageView];
//    
//    if(isDoubleTouch == YES && touch.phase == UITouchPhaseMoved)
//    {
//        
//        CGPoint newLocation = [touch locationInView:frameImageView];
//        int previousX = startLocation.x;
//        int previousY = startLocation.y;
//        
//        int currentX = newLocation.x;
//        int currentY = newLocation.y;
//        
//        int movedX, movedY;
//        movedX = currentX-previousX;
//        movedY = currentY - previousY;
//        
//        CGPoint imageCenter = self.view.center;
//        self.view.center = CGPointMake(imageCenter.x+movedX,imageCenter.y+movedY);
//        
//    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

@end
