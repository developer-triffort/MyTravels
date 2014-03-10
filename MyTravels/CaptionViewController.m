//
//  CaptionViewController.m
//  MyTravels
//
//  Created by Rahul Jain on 01/12/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import "CaptionViewController.h"
#import "FrameCationView.h"
#import <QuartzCore/QuartzCore.h>
#import "CaptionView.h"
#import "FrameCaptionViewController.h"

#define CAPION_IMAGES 9
#define CAP_WIDTH 85
#define CAP_HEIGHT 85
#define CAPTION_WIDTH 250

@interface CaptionViewController ()

@end

@implementation CaptionViewController

@synthesize superController;


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollView.frame = self.view.frame;
  
    [self updateCaptionView];

    self.view.backgroundColor = [UIColor lightTextColor];
   
    [closeButton addTarget:self action:@selector(capButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated
{
    [scrollView addSubview:captionView];
  scrollView.contentSize = captionView.bounds.size;
}


- (UIImage*)getScreenShot:(UIView*)view {
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return myImage;
}



- (void) updateCaptionView
{
    
    int row= 0;
    int col = 0;
    int imgName = 0;
    int space= 0;
    
    BOOL flag = [self hasFourInchDisplay];
    
    int width = superController.bgimageView.image.size.width;
    if(width < 480)
        space =  (320 - (CAP_WIDTH * 3))/2;
    else 
        space =  ((flag?568:480) - (CAP_WIDTH * 3))/4;
    
          
    
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
       
        UIImage *captionImage = [UIImage imageNamed:[NSString stringWithFormat:@"Caption%d",imgName]];
        
        FrameCationView *frameCaption = [[FrameCationView alloc] initWithImage:captionImage ImageSize:CGSizeMake(CAP_WIDTH, CAP_HEIGHT)];
        
        UIButton *capButton = [[UIButton alloc]initWithFrame:CGRectMake((col*CAP_WIDTH +(col*space)), ((row+1)*space+(row*CAP_HEIGHT)),CAP_WIDTH, CAP_HEIGHT)];
       
        capButton.tag = imgName;
        
        [capButton setImage:[self getScreenShot:frameCaption] forState:UIControlStateNormal];
        [capButton addTarget:self action:@selector(capButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [captionView addSubview:capButton];
        
        
        imgName++;
        
        
        if (col == 2) {
            col = 0;
            row++;
        } else {
            col++;
        }
         
    }
    
    
    if(width == 320)// staticaly set frame when images=9 for potrate
        captionView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height+space);
    else
        captionView.frame = CGRectMake(space,0, (col+1)*CAP_WIDTH+2*space, (row+1)*CAP_HEIGHT+row*space);
    
    NSLog(@"buton frame %f  %f and %d width",captionView.frame.size.width,captionView.frame.size.height,width);
        
    captionView.backgroundColor = [UIColor clearColor];
   
    
}

- (void) showCaptionPopup
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"To change font size, color or type, double tap on captions." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alertView show];
    [alertView release];

}
- (void) capButtonAction:(UIButton*) sender
{
    
    if(sender.tag == 9)
    {
        [superController.captionViewController.view removeFromSuperview];
        return;
    }
    else if(sender.tag == 0)
    {
           
        for(UIView *capview in superController.backView.subviews)
        {
           if(capview.tag == 3)
           {
               [capview removeFromSuperview];
               capview = nil;
               [capview release];
           }
        }
        [superController.captionViewController.view removeFromSuperview];
        [superController.captionsArray removeAllObjects];
        return;
    }
   
    CaptionView *captionObjView = [[CaptionView alloc] init];
    UIImage *captionImage = [UIImage imageNamed:[NSString stringWithFormat:@"Caption%d",sender.tag]];
    
    captionObjView.view.frame = CGRectMake(0, 0, CAPTION_WIDTH, CAPTION_WIDTH);
    captionObjView.view.center = superController.bgimageView.center;
    captionObjView.superController = superController;
    
    [superController.captionsArray addObject:captionObjView];    
    [superController.backView addSubview:captionObjView.view];

    captionObjView.view.tag = 3;
  
    [superController.captionViewController.view removeFromSuperview];
     
     captionObjView.captionImageView.image =  captionImage;
    
    [self performSelector:@selector(showCaptionPopup) withObject:nil afterDelay:0.5];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
