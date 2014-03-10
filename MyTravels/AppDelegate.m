//
//  AppDelegate.m
//  MyTravels
//
//  Created by Rahul kumar Jain on 30/10/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomAlertView.h"
#import "UIImageExtras.h"



#define ajeet @"4fa23934f77659e96800001a"
#define ajeetSce @"cea65258365e76208159df22c89dab28bbbe7b68"

@implementation UIView (extraFirstResponderMethod)
- (UIView *)getFirstResponder
{
    if (self.isFirstResponder)
        return self;
    
    
    for ( UIView * _pCurView in self.subviews )
    {
        UIView * _pFirstResponder = [_pCurView getFirstResponder];
        
        if (_pFirstResponder != nil)
            return _pFirstResponder;
    }
    
    return nil;
}

@end
@implementation AppDelegate
@synthesize ImageForCaption;
@synthesize window;
@synthesize userImage,backImage;
@synthesize fontName,fontSize,fontColor;
@synthesize splashView,alertView;
@synthesize timer;
@synthesize isAlertOpen,fadeComplete;
@synthesize captionFontColo,captionFontName,captionFontSize;
@synthesize adView;


- (void)dealloc
{
    [splashView release];
  
    [super dealloc];
}

- (BOOL)hasFourInchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height > 500.0);
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.userImage = [[[UIImage alloc] init] autorelease];
    self.fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:Font_Size];
    
    NSLog(@"font size %d",fontSize);
    if(self.fontSize == 0)
        fontSize = 20;
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:Font_Color];
    self.fontColor = [(UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:colorData] retain];
    if(!colorData)
        self.fontColor = [UIColor blackColor];
    
    self.fontName = [[NSUserDefaults standardUserDefaults] valueForKey:Font_Name];
    if(!self.fontName)
        self.fontName =  @"ArialRoundedMTBold";
    
    NSData *capColorData = [[NSUserDefaults standardUserDefaults] objectForKey:Cap_Font_Color];
    captionFontColo = [(UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:capColorData] retain];
    if(!capColorData)
        captionFontColo = [UIColor blackColor];
    
  
    
    captionFontName = [[NSUserDefaults standardUserDefaults] valueForKey:Cap_Font_Name];
    if(!captionFontName)
        captionFontName = @"ArialRoundedMTBold";
    
    captionFontSize = [[NSUserDefaults standardUserDefaults] integerForKey:Cap_Font_Size];
    if(captionFontSize == 0)
        captionFontSize = 20;
    
    if([self hasFourInchDisplay])
        storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
    else
         storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    UIViewController *initViewController = [storyBoard instantiateInitialViewController];
    [self.window setRootViewController:initViewController]; 
    
    if([self hasFourInchDisplay])
         splashView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    else
        splashView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    fadeComplete = 10.0f;
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    /*
    Chartboost *chartBoost = [Chartboost sharedChartboost];
    
    chartBoost.appId = @"50fe792f17ba47500f0006aa ";
    chartBoost.appSignature = @"a8094df446f3fa81001dc23fc3a3f01daff93146";
    chartBoost.delegate = self;
    [chartBoost startSession];
     */
    
    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAll;
}

-(void)removeSpalsh
{
    [splashView removeFromSuperview];
    [self showInfo];

}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [splashView removeFromSuperview];
    timer = nil; 
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [splashView removeFromSuperview]; 
    
    //[timer invalidate];
    timer = nil;  
    
    [alertView dismiss:nil];
    alertView = nil;
    [alertView release];
    isAlertOpen = NO;   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
- (void)showInfo {
   
    [alertView show];
    isAlertOpen = YES;
     
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
   
    [[[[UIApplication sharedApplication] keyWindow]getFirstResponder] resignFirstResponder];
    
    
    [self.window addSubview:splashView];
    
    int splashNumber = (arc4random()%10)+1;
    
    if(splashNumber == 1 || splashNumber == 7 || splashNumber == 0)// This splas was remove
        splashNumber++;
        
    NSString *splashName = nil;
    //CGFloat resolution= 480;
    
    if([self hasFourInchDisplay])
    {
        splashName = [NSString stringWithFormat:@"Splash5iPhone%d.jpeg",splashNumber];
       // resolution = 568;
    }
    else
    {
        splashName = [NSString stringWithFormat:@"Splash%d.jpeg",splashNumber];
       // resolution = 480;
    }
    
    UIImage *img = [UIImage imageNamed:splashName];
    splashView.backgroundColor = [UIColor colorWithPatternImage:img];
    splashView.alpha = 1.0;
    
    if([self hasFourInchDisplay])
        alertView = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView_iPhone5" bundle:nil];
    else
        alertView = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView" bundle:nil];
    

    if(!timer)
        timer =  [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(removeSpalsh) userInfo:nil repeats:NO];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Charboost delagete

// Called before requesting an interestitial from the back-end
- (BOOL)shouldRequestInterstitial:(NSString *)location;
{
    return YES;
}

// Called when an interstitial has been received, before it is presented on screen
// Return NO if showing an interstitial is currently innapropriate, for example if the user has entered the main game mode.
- (BOOL)shouldDisplayInterstitial:(NSString *)location
{
    return YES;
}

// Called when an interstitial has been received and cached.
- (void)didCacheInterstitial:(NSString *)location
{
    NSLog(@"location is %@",location);
}

// Called when an interstitial has failed to come back from the server
- (void)didFailToLoadInterstitial:(NSString *)location
{
    NSLog(@"cache location is %@",location);

}

// Called when the user dismisses the interstitial
// If you are displaying the add yourself, dismiss it now.
- (void)didDismissInterstitial:(NSString *)location
{
    NSLog(@"Dissmiss interdtial location is %@",location);
}

// Same as above, but only called when dismissed for a close
- (void)didCloseInterstitial:(NSString *)location
{
    NSLog(@"close Intrestial %@",location);
}

// Same as above, but only called when dismissed for a click
- (void)didClickInterstitial:(NSString *)location
{
    NSLog(@"click on Intrestial %@",location);
}


// Called before requesting the more apps view from the back-end
// Return NO if when showing the loading view is not the desired user experience.
- (BOOL)shouldDisplayLoadingViewForMoreApps
{
    return YES;
}

// Called when an more apps page has been received, before it is presented on screen
// Return NO if showing the more apps page is currently innapropriate
- (BOOL)shouldDisplayMoreApps
{
    return YES;
}

// Called when the More Apps page has been received and cached
- (void)didCacheMoreApps
{
    NSLog(@"cache for more apps");
}

// Called when a more apps page has failed to come back from the server
- (void)didFailToLoadMoreApps
{
      NSLog(@"fail to load more apps");
}

// Called when the user dismisses the more apps view
// If you are displaying the add yourself, dismiss it now.
- (void)didDismissMoreApps;
{
      NSLog(@"Dissmiss more apps");
}

// Same as above, but only called when dismissed for a close
- (void)didCloseMoreApps
{
      NSLog(@"Close more apps");
}

// Same as above, but only called when dismissed for a click
- (void)didClickMoreApps
{
      NSLog(@"click on more apps");
}



// Whether Chartboost should show ads in the first session
// Defaults to YES
- (BOOL)shouldRequestInterstitialsInFirstSession
{
    return YES;
}

@end
