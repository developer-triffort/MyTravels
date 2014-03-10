//
//  UserImageView.m
//  MyTravels
//
//  Created by Rahul Jain on 18/10/12.
//  Copyright (c) 2012 rahul kuamr jain. All rights reserved.
//

#import "UserView.h"
#import "EditingViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageProccessing.h"

#define U_WIDTH 200
#define U_HEIGHT 303

@implementation UserView

@synthesize imageView;
@synthesize editController;
@synthesize isDoubleTouch;
@synthesize startLocation;
@synthesize lastScale,currentScale,lastRotation;
@synthesize pinchGesture,rotateGesture;
@synthesize lastPoint;

- (id)init
{
    self = [super init];
    
    if(self)
    {
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self.view.frame = CGRectMake(0, 0, 420, 420);
    self = [super init];
    if(self)
    {
        if(!imageView)
        {
            imageView = [[UIImageView alloc] initWithFrame:frame];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [self.view addSubview:imageView];
        }
        imageView.center = self.view.center;
        
        //imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;

       
        
        self.view.userInteractionEnabled = YES;
        self.view.multipleTouchEnabled = YES;

        self.view.backgroundColor = [UIColor clearColor];
        
        //[self.view sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    
    pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGuestureAction:)];
    [self.view addGestureRecognizer:pinchGesture];
    pinchGesture.delegate = self;
    
    
    rotateGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotateBackView:)];
    [self.view addGestureRecognizer:rotateGesture];
    rotateGesture.delegate = self;

}


-(void)rotateBackView:(id)sender
{
        
	if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		lastRotation = 0.0;
		return;
	}
	
	CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
	
	CGAffineTransform oldTransform = imageView.transform;//[(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformRotate(oldTransform,rotation);
	
	[imageView setTransform:newTransform];
	
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
    if(currentScale >= 0.3f)
    {
        
        CGAffineTransform oldTransform = CGAffineTransformIdentity;
        CGAffineTransform newTransform = CGAffineTransformScale(oldTransform,currentScale,currentScale);
        
        [imageView setTransform:newTransform];
        NSLog(@"pinch %f",currentScale);
        
    }
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self.view];
    UITouch *touch = [[event allTouches] anyObject];
    startLocation = pt;
    isDoubleTouch = NO;
    if([[event allTouches] count] == 2 && touch.phase == UITouchPhaseBegan)
   {
        isDoubleTouch = YES;
//        NSLog(@"rouch began cod x =%f and cod y= %f",self.view.center.x,self.view.center.y);
        return;
   }
//      
//    isDoubleTouch = NO;

}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint touchLocation = [touch locationInView:imageView];
     if([[event allTouches] count] == 2)
         isDoubleTouch = YES;
         
    if(!editController.isEraserSelected && !editController.isUnEraserSelected && !isDoubleTouch)
    {
       
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
    else
    {
        touchLocation = [touch locationInView:imageView];
        CGFloat x = touchLocation.x-editController.eraserWidth/4;
        CGFloat y = touchLocation.y-editController.eraserWidth/4;
        if(editController.isEraserSelected)
        {
            UIBezierPath*    erasePath;
                
            
            erasePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y, editController.eraserWidth,editController.eraserWidth)];
             
            UIImage *img = imageView.image;
            CGSize s = img.size;
            UIGraphicsBeginImageContext(s);
             
            CGContextRef g = UIGraphicsGetCurrentContext();
            CGContextAddPath(g,erasePath.CGPath);
            CGContextAddRect(g,CGRectMake(0,0,s.width,s.height));

            CGContextEOClip(g);
             
            [img drawAtPoint:CGPointZero];
            imageView.image = UIGraphicsGetImageFromCurrentImageContext();
             
            UIGraphicsEndImageContext();
              
        }
        else if(editController.isUnEraserSelected)
        {
            CGPoint touchLocation = [touch locationInView:self.view];
            if(CGRectContainsPoint(imageView.frame, touchLocation))
            {    
                CGPoint touchLocation = [touch locationInView:imageView];
                CGFloat x = touchLocation.x;
                CGFloat y = touchLocation.y;
                
                AppDelegate *appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
                UIImage *backImage = appdel.userImage;
                
                CGRect theRect = CGRectMake(x, y, editController.eraserWidth,  editController.eraserWidth);
                
                imageView.image = [ImageProccessing unEraseImageView:imageView realImage:backImage drawAt:theRect];
                /*
                UIGraphicsBeginImageContext(imageView.image.size);
                
                [imageView.image drawInRect:CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height)];
                
                
                
                CGImageRef mySubimage = CGImageCreateWithImageInRect (backImage.CGImage, theRect);
                
                UIImage *subImage = [[[UIImage alloc] initWithCGImage:mySubimage] autorelease];
                
                [[subImage imageWithRadius:editController.eraserWidth/2 width:editController.eraserWidth height:editController.eraserWidth] drawAtPoint:CGPointMake(x, y)];
                
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                CGContextEOClip(context);
                
                imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                 */
           
            }
        }
          
    }    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

        UITouch *touch = [[event allTouches] anyObject];
    
        if([[event allTouches] count] == 2)
        {
           // startLocation = [touch locationInView:self.view];
           
        }
        else 
        {
            CGPoint touchLocation = [touch locationInView:self.view];
            if(CGRectContainsPoint(imageView.frame, touchLocation))
            {
                if(imageView.image)
                    [editController.unEraseArray addObject:[imageView.image copy]];
                
                [editController hideEraserSlider];
                
            }

        }
       
 }

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}



@end
