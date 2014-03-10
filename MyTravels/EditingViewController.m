//
//  EditingViewController.m
//  MyTravels
//
//  Created by Rahul kuamr Jain on 02/11/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import "EditingViewController.h"
#import "AppDelegate.h"
#import "FrameCaptionViewController.h"
#import "UIImageExtras.h"
#import "ImageProccessing.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomAlertView.h"
#import "GrowingTextView.h"
#import "CustomAlertView.h"
#import "ImagePickerController.h"
#import "UserView.h"

#import "GADBannerView.h"
#import "GADRequest.h"



#define OUTERPADDING 160
#define U_WIDTH 300
#define U_HEIGHT 300


@interface EditingViewController ()

- (IBAction)selectImage:(id)sender;
- (void) showAdwhirl;

@end

@interface UIDevice ()
-(void)setOrientation:(UIDeviceOrientation)orientation;

@end

@implementation EditingViewController

@synthesize userViewController;
//@synthesize adBanner = adBanner_;
@synthesize unEraseArray;
@synthesize bgimageView;
@synthesize isDoubleTouch;
@synthesize bgImage;
@synthesize startLocation;
@synthesize isFirstInstrustion;

@synthesize eraserWidth;
@synthesize isEraserSelected,isScrollingEnable;

@synthesize isPreview;
@synthesize isUnEraserSelected;
@synthesize scrollView;
@synthesize tabBar;
@synthesize isPushtoMoreScreen;

float currentScale;
float lastScale;

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

-(void)showHelpScreen
{
    CustomAlertView *alertView = nil;
    
    if([self hasFourInchDisplay])
        alertView = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView_iPhone5" bundle:nil];
    else
        alertView = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView" bundle:nil];
    
    [alertView show];
    [alertView release];
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
    UIButton *photoButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 105, 26)] autorelease];
    [photoButton setImage:[UIImage imageNamed:@"choosephoto.png"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *choosePhotoBarButton = [[[UIBarButtonItem alloc] initWithCustomView:photoButton] autorelease];

    
    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 26)] autorelease];
    [backButton setImage:[UIImage imageNamed:@"BackButton.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [helpButton addTarget:self action:@selector(showHelpScreen) forControlEvents:UIControlEventTouchUpInside];
    //[helpButton ]
    UIBarButtonItem *helpBarButton = [[[UIBarButtonItem alloc]initWithCustomView:helpButton] autorelease];
     
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:helpBarButton,choosePhotoBarButton,nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backBarButton,nil];

    self.scrollView.frame = bgimageView.frame;
    self.scrollView.scrollEnabled = NO;

    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.bgimageView.image = self.bgImage;
    
       
    unEraseArray = [[NSMutableArray alloc]init];
   
        
    delegate.backImage = bgImage;
    
    eraserWidth = 40.0f;
    
    self.tabBar.selectedItem = [[tabBar items] objectAtIndex:0];
    
    [self hideEraserSlider];
    

    isScrollEnable = NO;
    
    [AccelerometerHelper sharedInstance].delegate = self;
	[self loadSound:&sound called:@"whoosh"];
    
    [[UIDevice currentDevice] setOrientation:UIDeviceOrientationPortrait];
    
    if(!userViewController)
        userViewController = [[UserView alloc] init];
     [self.scrollView addSubview:userViewController.view];
    
     
    /*

     

    RevMobAds *revmob = [RevMobAds session];
    
   // if(TARGET_IPHONE_SIMULATOR)
        revmob.testingMode = YES;
    
    banner = [[revmob bannerView] retain];
    [banner loadAd];
    
    banner.delegate = self;
    
    banner.backgroundColor = [UIColor redColor];
      [scrollView addSubview:banner];
    
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = ADMOB_PUBLISHER_ID;
    interstitial_.delegate = self;
    [interstitial_ loadRequest:[GADRequest request]];
    
*/
   
}
- (void) viewDidAppear:(BOOL)animated
{
    CGSize imgSize = self.bgImage.size;
   
 
    if(UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        if(imgSize.width>imgSize.height)
        {
            //CGPoint origin = CGPointMake(0.0,self.scrollView.frame.size.height -168);

            [[UIDevice currentDevice] setOrientation:UIDeviceOrientationLandscapeLeft];
            // banner.frame = CGRectMake(origin.x, origin.y, 480, 20);
            
        }
        else
        {
            //CGPoint origin = CGPointMake(0.0,self.scrollView.bounds.size.height -20);

            [[UIDevice currentDevice] setOrientation:UIDeviceOrientationPortrait];
             //banner.frame = CGRectMake(origin.x, origin.y, 320, 20);
        }
    }
    bgimageView.image = bgImage;
    
 
    [self performSelector:@selector(showAdwhirl) withObject:nil afterDelay:.03];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self hideEraserSlider];
    
}

-(void)backButtonAction : (UIButton*) sender
{
    UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"Alert !" message:@"If you go back, all current work will be lost." delegate:self cancelButtonTitle:@"Do NOT go back" otherButtonTitles:@"Go Back", nil];
    alertView.tag = 102;
    [alertView show];
    [alertView release];
}

- (IBAction)selectImage:(id)sender {

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select image source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Photo library" otherButtonTitles:@"Camera", nil];
    
    [actionSheet showFromTabBar:self.tabBar];
    [actionSheet release];
    
}

- (void) showEraserSliderBar
{
    erserSlider.alpha = 1.0;

    [UIView beginAnimations:@"" context:nil];
    
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
        erserSlider.frame = CGRectMake(70, 80, 178, 23);
    else
        erserSlider.frame = CGRectMake(70, 20, 178, 23);
    
     AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.window addSubview:erserSlider];
    
    [UIView commitAnimations];
}

- (void) hideEraserSlider
{
    erserSlider.alpha = 0.0;
    [UIView beginAnimations:@"" context:nil];
    erserSlider.frame = CGRectMake(70, -10, 178, 23);
    [UIView commitAnimations];
}

-(IBAction)eraserSliderAction:(UISlider*)sender
{
    eraserWidth = sender.value;
}

- (UIImage *)snapShot
{
    UIImage *filterImage = nil;
    if(!userViewController.imageView.image)
    {
        filterImage = bgImage;
    }
    else
    {
          /*
        CGSize imageSize = bgimageView.frame.size;
        
        UIGraphicsBeginImageContextWithOptions(imageSize, YES, [[UIScreen mainScreen] scale]);
        
        [bgimageView.image drawInRect:CGRectMake(0,0,imageSize.width,imageSize.height)];
        
        
        for(UIView *view in scrollView.subviews)
        {
          
            CGContextRef context = UIGraphicsGetCurrentContext();
            // -renderInContext: renders in the coordinate space of the layer,
            
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            
            if(view.tag == 101)
            {

                
                // Center the context around the window's anchor point
                CGContextTranslateCTM(context, [userViewController.view center].x, [userViewController.view center].y);
                
                
                CGContextConcatCTM(context, [userViewController.view transform]);
                
                
                // Offset by the portion of the bounds left of and above the anchor point
                CGContextTranslateCTM(context,
                                      -[userViewController.view bounds].size.width * [[userViewController.view layer] anchorPoint].x,
                                      -[userViewController.view bounds].size.height * [[userViewController.view layer] anchorPoint].y);
                //CGRect frame = userViewController.imageView.frame;
                //[userViewController.imageView.image drawAtPoint:userViewController.imageView.frame.origin];
               
                
                // Render the layer hierarchy to the current context
                [[userViewController.view layer] renderInContext:context];
                
                // Restore the context
                
                 

            }
            else
            {
                // Center the context around the window's anchor point
                CGContextTranslateCTM(context, [view center].x, [view center].y);
                
                
                CGContextConcatCTM(context, [view transform]);
                
                
                // Offset by the portion of the bounds left of and above the anchor point
                CGContextTranslateCTM(context,
                                      -[view bounds].size.width * [[view layer] anchorPoint].x,
                                      -[view bounds].size.height * [[view layer] anchorPoint].y);
                
                
                // Render the layer hierarchy to the current context
                [[view layer] renderInContext:context];
                
                // Restore the context
              

            }
            
            CGContextRestoreGState(context);
            // Retrieve the screenshot image
        }
        filterImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        */
       
         filterImage =  [[ImageProccessing sharedInstance] convertViewIntoUIimage:scrollView];
        
    }

    
    

    return filterImage;
}

#pragma mark - Tab bar Delegate

- (void) undoAction
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [unEraseArray removeLastObject];
    
    if([unEraseArray count] == 0)
        userViewController.imageView.image = delegate.userImage;
    else
        userViewController.imageView.image = (UIImage*)[unEraseArray lastObject];

}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (item.tag == 0)
    {   // Move
        
        isUnEraserSelected = NO;
        isEraserSelected = NO;

    }
    else if (item.tag == 1)
    {   // Erase
        [self showEraserSliderBar];
    
        if (!isEraserSelected)
        {
            isEraserSelected =  YES;
            isUnEraserSelected = NO;        
        }
    }

    else if (item.tag == 2)
    {   // Unerase
    
        if(!isUnEraserSelected)
        {
            isUnEraserSelected =  YES;
            isEraserSelected = NO;
        }
    }
    else if (item.tag == 3)
    { // Frame/caption
        
        
        FrameCaptionViewController *frameCaptionController;
        
        if([self hasFourInchDisplay])
            frameCaptionController = [self.storyboard instantiateViewControllerWithIdentifier:@"FrameCaption_iPhone5"];
        else
            frameCaptionController = [self.storyboard instantiateViewControllerWithIdentifier:@"FrameCaption"];
        
        frameCaptionController.superController = self;
        delegate.ImageForCaption = [self snapShot];
       
        isPushtoMoreScreen = YES;
        [self.navigationController pushViewController:frameCaptionController animated:YES];
        
        frameCaptionController.bgimageView.image = [delegate.ImageForCaption copy];
        
        [frameCaptionController release];
        
        //[[Chartboost sharedChartboost] showInterstitial];
        
    }
    else if (item.tag == 4)
    {//Undo
        [self undoAction];
    }
}

#pragma mark - Action sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    if(actionSheet.tag == 2)
    {
    
    }
    else
    {
        
    if (buttonIndex == 0) {
        
        UIImagePickerController* imagePicker = [[ImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            imagePicker.allowsEditing = NO;
            [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
           
            
        }
        else {
            
            UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to access Photo Library" delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
            [error show];
            [error release];
        }
    }
    
    else if (buttonIndex == 1){
        NSLog(@"cam");
        
        UIImagePickerController* imagePicker = [[ImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.allowsEditing = NO;
            [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
           
        }
        else {
            
            UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to access Camera" delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
            [error show];
            [error release];
        }
    }
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    [picker dismissModalViewControllerAnimated:YES];
        
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"%f height %f",image.size.width,image.size.width);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, U_WIDTH, U_HEIGHT)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIImage *tempImage = [[ImageProccessing sharedInstance] convertViewIntoUIimage:imageView];
    delegate.userImage = tempImage;
   
    [userViewController initWithFrame:CGRectMake(0, 0, U_WIDTH, U_HEIGHT)];
    userViewController.imageView.image = [delegate.userImage copy];
    
    
    userViewController.view.center = backView.center;
    userViewController.view.tag = 101; // recoginize userview's view within scrollview subviews.
    userViewController.view.userInteractionEnabled = YES;
    userViewController.view.multipleTouchEnabled = YES;
    
    userViewController.editController = self;
   
    if(!isFirstInstrustion)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Reminder" message:@"Use 2 fingers to resize and rotate photo." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        isFirstInstrustion  = YES;
    }
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
    {
        if(buttonIndex == 1)
        {
             AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            [unEraseArray removeLastObject];
            
            if([unEraseArray count] == 0)
                userViewController.imageView.image = delegate.userImage;
            else
                userViewController.imageView.image = (UIImage*)[unEraseArray lastObject];

        }
    }
    if(alertView.tag == 102)
    {
        if (buttonIndex == 1) {
            [adView ignoreNewAdRequests];
            bgimageView.image = nil;
           
            [self.navigationController popViewControllerAnimated:YES];
            
            userViewController.imageView.image = nil;
            
        }
    }
}

#pragma mark  sounds

- (void) loadSound: (SystemSoundID *) aSound called: (NSString *) aName
{
	NSString *sndpath = [[NSBundle mainBundle] pathForResource:aName ofType:@"aif"];
	CFURLRef baseURL = (CFURLRef)[NSURL fileURLWithPath:sndpath];
    AudioServicesCreateSystemSoundID(baseURL, aSound);
	AudioServicesPropertyID flag = 0;
	AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), aSound, sizeof(AudioServicesPropertyID), &flag);
}

- (void) playSound: (SystemSoundID) aSound
{
	AudioServicesPlaySystemSound(aSound);
}

-(void) dealloc
{
    [super dealloc];
	if (sound) AudioServicesDisposeSystemSoundID(sound);
}

#pragma mark AccelerometerHelper

- (IBAction) updateTimeLockout: (UISlider *) slider
{
	//timelock.text = [NSString stringWithFormat:@"%4.2f", slider.value];
	[[AccelerometerHelper sharedInstance] setLockout:slider.value];
}

- (IBAction) updateSensitivity: (UISlider *) slider
{
	//sensitivity.text = [NSString stringWithFormat:@"%4.2f", slider.value];
	[[AccelerometerHelper sharedInstance] setSensitivity:slider.value];
}

- (void) ping
{
	//float change = [[AccelerometerHelper sharedInstance] dAngle];
	//acceleration.text = [NSString stringWithFormat:@"%4.2f", change];
}

- (void) shake
{
    if(!isPushtoMoreScreen)
    {
        [self performSelectorInBackground:@selector(undoAction) withObject:nil];
        
        if([unEraseArray count]!=0)
            [self playSound:sound];
    }
}



#pragma mark - GestureRecognizer
- (BOOL)shouldAutorotate{
    
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    if(bgImage.size.width>bgImage.size.height )
    {
            return UIInterfaceOrientationMaskLandscape;
    }
    
    if(bgImage.size.width<bgImage.size.height)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if(bgImage.size.width>bgImage.size.height )
    {
        if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
            return YES;
    }
    
    if(bgImage.size.width<bgImage.size.height)
    {
        if(toInterfaceOrientation == UIInterfaceOrientationPortrait)
            return YES;
    }
   
    return NO;
    
}
#pragma mark - AdwhirlView

- (void) showAdwhirl
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(!delegate.adView)
    {
        adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
        delegate.adView = [adView retain];
    }
    adView =delegate.adView;

      // implement Adwhirl
   
        
    adView.autoresizesSubviews = YES;
    
    CGPoint origin = CGPointMake((self.view.bounds.size.width - adView.frame.size.width)/ 2,
                                 self.view.frame.size.height -
                                 98);
    adView.frame = CGRectMake(origin.x, origin.y, adView.frame.size.width, adView.frame.size.height);
    [backView addSubview:adView];
    
}

- (NSString *)adWhirlApplicationKey {
    
	return ADWHIRL_KEY;
	
}



- (UIViewController *)viewControllerForPresentingModalView {
	
	return self;
	
}



- (void)adWhirlDidFailToReceiveAd:(AdWhirlView *)adWhirlView usingBackup:(BOOL)yesOrNo
{
    
    NSLog(@"Failed to recieve aid");
    
    NSLog(@"%@",[NSString stringWithFormat:
                 @"Failed to receive ad from %@, %@. Error: %@",
                 [adWhirlView mostRecentNetworkName],
                 yesOrNo? @"will use backup" : @"will NOT use backup",
                 adWhirlView.lastError == nil? @"no error" : [adWhirlView.lastError localizedDescription]]);
    
    
}




- (void)adWhirlDidReceiveConfig:(AdWhirlView *)adWhirlView
{
    NSLog(@"Configure section is executed");
    
       
}



- (void)adWhirlDidAnimateToNewAdIn:(AdWhirlView *)adWhirlView{
    
}



- (void)adWhirlReceivedNotificationAdsAreOff:(AdWhirlView *)adWhirlView{
    NSLog(@"adds are off");
}

//adWhirlClickMetricURL


- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView {
	
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
	[UIView beginAnimations:@"AdWhirlDelegate.adWhirlDidReceiveAd:"context:nil];
	
	[UIView setAnimationDuration:0.7];
	
	CGSize adSize = [appdelegate.adView actualAdSize];
	
	CGRect newFrame = appdelegate.adView.frame;
	
	
	newFrame.size = adSize;
	
	newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
     
   
        newFrame.origin.y = self.view.frame.size.height -
        98;
	
	appdelegate.adView.frame = newFrame;
    
	[UIView commitAnimations];
    


}




@end
