//
//  FrameViewController.m
//  MyTravels
//
//  Created by Rahul Jain on 01/12/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import "FrameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FrameCationView.h"
#import "FrameCaptionViewController.h"
#import "ImageProccessing.h"

#import "AppDelegate.h"
#define CAPION_IMAGES 11
#define CAP_WIDTH 100
#define CAP_HEIGHT 100

@interface FrameViewController ()

@end

@implementation FrameViewController
@synthesize superController;
@synthesize appliedFrameView;
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
	// Do any additional setup after loading the view.
    
    [closeButton addTarget:self action:@selector(frameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
   // [self updateFrameView];
    self.view.backgroundColor = [UIColor lightGrayColor];


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}


- (UIImage*)getScreenShot:(UIView*)view {
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return myImage;
}


/*
- (void) updateFrameView
{
    NSString *orientationMode= nil;
    CGFloat width = CAP_WIDTH;
    
    if(UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        orientationMode = @"Land";
        width = 150;
        
    }
    else
        orientationMode = @"Pot";
        
    int row= 0;
    int col = 0;
    int imgName = 0;
    int space= 0;
    
    if(UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))
        space =  (320 - (width * 3))/4;
    else
        space =  (480 - (width * 3))/4;
    
    for(int i = 0 ; i < CAPION_IMAGES ; i++)
    {
        if(imgName == CAPION_IMAGES)
        {
            imgName= 0;
        }
        
        if(space<0)
            space = 0;
        NSLog(@"Space %d",space);
        NSLog(@"row %d",row);
        NSLog(@"col %d",col);
        UIImage *captionImage = [UIImage imageNamed:[NSString stringWithFormat:@"frame%@%d",orientationMode,imgName]];
        
        FrameCationView *frameCaption = [[FrameCationView alloc] initWithImage:captionImage ImageSize:CGSizeMake(width, CAP_HEIGHT)];
               
        UIButton *frameBorder;
       
        if(UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))
            frameBorder = [[UIButton alloc]initWithFrame:CGRectMake((col+1)*space + col*width, (row+1)*space +row*CAP_HEIGHT,width, CAP_HEIGHT)];
        else
            frameBorder = [[UIButton alloc]initWithFrame:CGRectMake((col+1)*space + col*width, (row+1)*space/2 +row*CAP_HEIGHT,width, CAP_HEIGHT)];
        
        frameBorder.tag = imgName;
        [frameBorder setImage:[self getScreenShot:frameCaption] forState:UIControlStateNormal];
        [frameBorder addTarget:self action:@selector(frameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [frameView addSubview:frameBorder];
        
        
        imgName++;
        
        
        if (col == 2) {
            col = 0;
            row++;
        } else {
            col++;
        }
        frameView.frame = CGRectMake(0, 0, self.view.frame.size.width-space, ((row+1)*CAP_HEIGHT)+(row+1)*space+CAP_HEIGHT);
         
        if(UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))  
            frameView.frame = CGRectMake(0, space/2, self.view.frame.size.width-space, ((row+1)*CAP_HEIGHT)+(row+1)*space);
    }
    NSLog(@"buton frame %f  %f",frameView.frame.size.width,frameView.frame.size.height);
    
    frameView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = frameView.bounds.size;
    [scrollView addSubview:frameView];
}
*/
- (void) frameButtonAction:(UIButton*) sender
{
     NSString *orientationMode= nil;
    if(superController.bgimageView.image.size.width> superController.bgimageView.image.size.height)
        orientationMode = @"Land";
    else
        orientationMode = @"Pot";
    
    if(sender.tag == 11)
    {
        [superController.frameViewController.view removeFromSuperview];
        return;
    }
    else if (sender.tag == 10){
        appliedFrameView.frameImageView.image = nil;
        [superController.frameViewController.view removeFromSuperview];
        return;
    }

    [superController.frameViewController.view removeFromSuperview];
    
    UIImage *frameImage =  [UIImage imageNamed:[NSString stringWithFormat:@"frame%@%d.png",orientationMode,sender.tag]];
 
    if(!appliedFrameView)
    {
        appliedFrameView = [[FrameView alloc] init];
        
        if(UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))
        {
            appliedFrameView.view.frame = CGRectMake(0, 0, 320, 388);  
        }
        else 
        {
            appliedFrameView.view.frame = CGRectMake(0, -1, 480, 243);
        }

        [superController.backView addSubview:appliedFrameView.view];
        appliedFrameView.view.userInteractionEnabled = NO;
    }
    
   // appliedFrameView.view.tag =  2; //dedeuct subview on frameCaptionView
   // AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appliedFrameView.frameImageView.image = frameImage;
    //appliedFrameView.frameImageView.image = [[ImageProccessing sharedInstance] screenShot:[frameImage resizeToSize:CGSizeMake(1060, 580) thenCropWithRect:CGRectMake(50, 50, 960, 480)] :appDel.backImage];
    
    [superController.frameViewController.view removeFromSuperview];
    
    superController.isFrameApply =  YES;
}

@end
