//
//  TextViewController.m
//  MyTravels
//
//  Created by Triffort on 23/11/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import "TextViewController.h"
#import "FrameCaptionViewController.h"


@interface TextViewController ()

@end

@implementation TextViewController
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - toolbar button Action
- (IBAction)removeText : (UIBarButtonItem *)sender
{
    [superController removeText];
    addTextButton.enabled = YES;
}

-(IBAction)showText :(UIBarButtonItem *)sender
{
    [superController showTextView];
    addTextButton = sender;
     sender.enabled = NO;
}


- (IBAction)showFontName
{
    FontViewController *fontViewController= nil;
    
    if([self hasFourInchDisplay])
        fontViewController = [superController.storyboard instantiateViewControllerWithIdentifier:@"FontDetailController_iPhone5"];
    else
         fontViewController = [superController.storyboard instantiateViewControllerWithIdentifier:@"FontDetailController"];
    
    [superController.navigationController pushViewController:fontViewController animated:YES];
    fontViewController.superController = superController;
    //[self.navigationController pushViewController:fontViewController animated:YES];
}
@end
