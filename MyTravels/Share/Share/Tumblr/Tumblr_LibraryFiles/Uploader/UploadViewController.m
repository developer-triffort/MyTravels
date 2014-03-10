//
//  UploadViewController.m
//  Tumblr
//
//  Created by Kashif Jilani on 12/30/12.
//  Copyright (c) 2012 Kashif Jilani. All rights reserved.
//

#import "UploadViewController.h"
//#import "AppDelegate.h"
#import "ViewController.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

@synthesize blogString,tumblrCaption,tumblrImage;
@synthesize superController;


-(id)initWithData:(NSMutableArray *)dataArray {
    
    blogArray = dataArray;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *uploadBtn = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStyleDone target:self action:@selector(uploadImage)];
    self.navigationItem.rightBarButtonItem = uploadBtn;
    
    if([blogArray count]>0)
        [blogTableView reloadData];
    [uploadBtn release];
    
    acitvityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    acitvityIndicator.hidesWhenStopped = YES;
    
    acitvityIndicator.frame = CGRectMake(0, 0, 100, 100);
    
    [self.view addSubview:acitvityIndicator];
    acitvityIndicator.center = [[UIApplication sharedApplication] keyWindow].center;
    [acitvityIndicator stopAnimating];
    
    self.view.backgroundColor = [UIColor clearColor];
    
}

-(void)uploadImage {
    
    //AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //NSData *data1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picture1" ofType:@"jpg"]];
    NSData *data1 = [[NSData alloc] initWithData:UIImagePNGRepresentation(tumblrImage)];
    
    NSArray *array = [NSArray arrayWithObject:data1];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TumblrUploadr *tu = [[TumblrUploadr alloc] initWithNSDataForPhotos:array andBlogName:self.blogString andDelegate:self andCaption:tumblrCaption];
        dispatch_async( dispatch_get_main_queue(), ^{
            //[tu signAndSendWithTokenKey:delegate.OAuthKey andSecret:delegate.OAuthSecret];
            [tu signAndSendWithTokenKey:superController.OAuthKey andSecret:superController.OAuthSecret];

            
        });
    });
}

- (void) tumblrUploadr:(TumblrUploadr *)tu didFailWithError:(NSError *)error {
    NSLog(@"connection failed with error %@",[error localizedDescription]);
    
    [SVProgressHUD dismissWithError:@"Error in uploading image"];
    [blogArray removeAllObjects];
    
    [acitvityIndicator stopAnimating];
    
    [tu release];
}
- (void) tumblrUploadrDidSucceed:(TumblrUploadr *)tu withResponse:(NSString *)response {
    NSLog(@"connection succeeded with response: %@", response);
    
    [SVProgressHUD showWithStatus:@"Image uploaded successfully." maskType:SVProgressHUDMaskTypeGradient networkIndicator:YES];
    [self performSelector:@selector(removeView) withObject:nil afterDelay:1.5];
    [blogArray removeAllObjects];
    
    [acitvityIndicator stopAnimating];
    
    superController.isPostSuccessfully = YES;
    
    [tu release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// TABLE VIEW DELEGATE AND MEHTODS

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [blogArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }    // Configure the cell...
    cell.textLabel.text = [blogArray objectAtIndex:indexPath.row];
    return cell;
}


-(void) removeView
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"dissMissController" object:nil];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.userInteractionEnabled = NO;
    
    NSString *dataString = [blogArray objectAtIndex:indexPath.row];
    self.blogString = [NSString stringWithFormat:@"%@.tumblr.com",dataString];
    [self uploadImage];
    [acitvityIndicator startAnimating];
  
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
