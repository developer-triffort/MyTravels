//
//  HomeViewController.m
//  MyTravels
//
//  Created by Mohd Muzammil on 30/10/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import "HomeViewController.h"
#import "EditingViewController.h"
#import "ImageProccessing.h"

#import "CustomAlertView.h"
#import "PhotoGridView.h"

@interface HomeViewController ()

- (void)showInfo;
- (IBAction)selectPlace:(id)sender;
- (IBAction)selectPhoto:(id)sender;
- (IBAction)letsGo:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *placeImgView;
@property (strong, nonatomic) IBOutlet UIImageView *photoImgView;

@end

@interface UIDevice ()
-(void)setOrientation:(UIDeviceOrientation)orientation;

@end

@implementation HomeViewController
@synthesize placeImgView,photoImgView;

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
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    PhotoGridView *gridView;
    if([self hasFourInchDisplay])
        gridView = [[PhotoGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
    else
        gridView = [[PhotoGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [gridView drawImageView];
    gridView.classDelegate = self;

    [self.view addSubview:gridView];
    //[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(showInfo) userInfo:nil repeats:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
   [[UIDevice currentDevice] setOrientation:UIDeviceOrientationPortrait];
    
    NSLog(@"Device version %@",[[UIDevice currentDevice] systemName]);

}
- (void)showInfo {

    CustomAlertView *alertView = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView" bundle:nil];
    [alertView show];
    [alertView release];
}

-(void) updateImage: (UIImage *)image
{
    
}
- (void)selectedBackground:(UIImage*)image {

   // EditingViewController *editingViewController;
    
    
  //  UIStoryboard *storyboard = [UIStoryboard ]
    if (!editingViewController) {
        if([self hasFourInchDisplay])
            editingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditingController_iPhone5"];
        else
            editingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditingController"];
    }
  
  
   // [self performSelectorInBackground:@selector(updateImage:) withObject:[image copy]];
 
    if(image.size.width>image.size.height)
    {
        //UIImage *tempImage = [image scaleImage:image toResolution:480];
        // CGRect cropRect = CGRectMake(tempImage.size.width/2-160, tempImage.size.height/2-240, 320, 480);
        //CGImageRef imageRef = CGImageCreateWithImageInRect([tempImage CGImage], cropRect);
        // or use the UIImage wherever you lik
        editingViewController.bgImage = image;//[UIImage imageWithCGImage:imageRef];
        //CGImageRelease(imageRef);
        
    }
    else
        editingViewController.bgImage = image;//[image scaleImage:image toResolution:360];

       
    [self.navigationController pushViewController:editingViewController animated:YES];

    
}

#pragma mark - Button Action

- (IBAction)selectPlace:(id)sender{
    

}

- (IBAction)selectPhoto:(id)sender{
    
    
}

- (IBAction)letsGo:(id)sender{
    
    UIImage *photoImage = self.photoImgView.image;
    UIImage *placeImage = self.placeImgView.image;
    
    if (photoImage == nil || placeImage == nil) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select Photo Image and Place Image." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show]; [alertView release];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - GestureRecognizer
- (BOOL)shouldAutorotate {
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;// | UIInterfaceOrientationMaskPortraitUpsideDown;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
