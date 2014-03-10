//
//  ViewController.m
//  Tumblr
//
//  Created by Kashif Jilani on 12/30/12.
//  Copyright (c) 2012 Kashif Jilani. All rights reserved.
//

#import "ViewController.h"
//#import "AppDelegate.h"
#import "TumblrConnect.h"
#import "UploadViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize navController;
@synthesize tumblrCaption,tumblrImage;
@synthesize OAuthKey,blogsArray,OAuthSecret;
@synthesize isPostSuccessfully;

-(void)dealloc
{
    [super dealloc];
    [blogsArray release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    TumblrConnect *tumConect = [[TumblrConnect alloc] init];
    tumConect.superController = self;
    [tumConect connectTumblr];
    
    //navController = [[UINavigationController alloc] init];
    
    blogsArray = [[NSMutableArray alloc] init]; // store tumblr blogs name
    
    NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
	[noteCenter addObserver:self selector:@selector(moveToUpload) name:@"moveToUpload" object:nil];
    [noteCenter addObserver:self selector:@selector(dissMissController) name:@"dissMissController" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tmblr.png"]];
        
}
- (void)viewDidDisappear:(BOOL)animated
{
    if(isPostSuccessfully)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showAppirater" object:nil];
}
-(void)moveToUpload
{
   // AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   // UploadViewController *uploadImage = [[UploadViewController alloc] initWithData:delegate.blogsArray];
    UploadViewController *uploadImage = [[UploadViewController alloc] initWithData:blogsArray];

    uploadImage.superController = self;
    
    uploadImage.view.frame = CGRectMake(0, 44, 320, 436);
    uploadImage.tumblrImage=tumblrImage;
    uploadImage.tumblrCaption = tumblrCaption;
    
    [self.view addSubview:uploadImage.view];
   // [uploadImage release];
}

- (IBAction)dissMissController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
       [SVProgressHUD dismiss];
   // [self release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
