//
//  FrameCaptionViewController.m
//  MyTravels
//
//  Created by Rahul Kumar Jain on 02/11/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import "FrameCaptionViewController.h"
#import "EditingViewController.h"
#import "AppDelegate.h"
#import "TextViewController.h"
#import "CaptionViewController.h"
#import "FrameViewController.h"
#import "CaptionView.h"
#import "ShareController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "ImageProccessing.h"


@interface FrameCaptionViewController ()

- (void) showAdwhirl;


@end

@implementation FrameCaptionViewController


@synthesize frameView;
@synthesize textField;
@synthesize superController;
@synthesize bgimageView;
@synthesize textViewController;
@synthesize quoteResizableView,quoteTextView;
@synthesize isKeyboardOpens,isShowTextController;
@synthesize selectedFont,fontSize;
@synthesize captionViewController;
@synthesize frameViewController;
@synthesize frameImageView;
@synthesize pinchGesture,isFrameApply,currentScale,lastScale,isDoubleTouch,startLocation;
@synthesize backView;
@synthesize captionsArray;


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

- (void)dealloc
{
    [super dealloc];
    [captionViewController release];
    [frameViewController release];
    [pinchGesture release];
    [captionsArray release];
}

- (void) removeText
{
    [quoteTextView resignFirstResponder];
    [quoteResizableView removeFromSuperview];
    quoteTextView = nil;
    quoteResizableView = nil;
    [quoteResizableView release];
    [quoteTextView release];
    
}

-(void) showTextView
{
    AppDelegate *appdelagte = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if(!quoteTextView)
    {
        
        quoteTextView = [[GrowingTextView alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];

        CGPoint center = self.view.center;
        center.y -= 50;
    
        quoteTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
        quoteTextView.minNumberOfLines = 1;
        quoteTextView.maxNumberOfLines = 30;
        quoteTextView.returnKeyType = UIReturnKeyDone;
        quoteTextView.font = [UIFont boldSystemFontOfSize:appdelagte.fontSize];
        quoteTextView.textAlignment = NSTextAlignmentCenter;
        quoteTextView.delegate = self;
       
        quoteTextView.layer.borderColor = [UIColor clearColor].CGColor;
        quoteTextView.layer.borderWidth = 1.0;
            
        quoteTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        quoteTextView.backgroundColor = [UIColor clearColor];
    
        quoteResizableView = [[UserResizableView alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];

        quoteResizableView.center = center;
    
        quoteResizableView.contentView = quoteTextView;
        quoteResizableView.delegate = self;
    
        quoteTextView.resizableView = quoteResizableView;
           
    }
    quoteTextView.textColor = appdelagte.fontColor;
    quoteTextView.font = [UIFont fontWithName:appdelagte.fontName size:appdelagte.fontSize];
    
    quoteTextView.text = @"Your text here";//self.myQuote;
    
    [backView addSubview:quoteResizableView];
    
    currentlyEditingView = quoteResizableView;
    [currentlyEditingView showEditing];
    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:.03];
    quoteResizableView.tag =2;

}

- (void)isShowTextControllerView:(BOOL) show
{
    [UIView beginAnimations:@"" context:nil];
    isShowTextController = show;

    
    CGRect rect = textViewController.view.frame;
    if(show)
    {
        rect.origin.y = 0;
        textViewController.view.frame = rect;
    }
    else
    {
        rect.origin.y = -49;
        textViewController.view.frame = rect;

    }
    [UIView commitAnimations];
}

-(void)showCaptionView
{
    if(bgimageView.frame.size.width>bgimageView.frame.size.height)
    {
        if([self hasFourInchDisplay])
            captionViewController.view.frame = CGRectMake(0, 0, 568, 240);
        else
            captionViewController.view.frame = CGRectMake(0, 0, 480, 240);
    }
    
    if(bgimageView.frame.size.width<bgimageView.frame.size.height)
    {
        if([self hasFourInchDisplay])
            captionViewController.view.frame = CGRectMake(0, 0, 320, 476);
        else
            captionViewController.view.frame = CGRectMake(0, 0, 320, 388);

    }
   [AnimateViewHelper animateView:captionViewController.view];
    [self.view addSubview:captionViewController.view];
   
}

- (void) missingObjAlert: (NSString*)obj
{
    NSString *str = [NSString stringWithFormat:@"%@ not added yet!",obj];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert !" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}
-(void)showFrameView
{
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        frameViewController.view.frame = CGRectMake(0, 0, 320, 388);  
    }
    else 
    {
        frameViewController.view.frame = CGRectMake(0, 0, 480, 240);
    }
     [AnimateViewHelper animateView:frameViewController.view];
    [self.view addSubview:frameViewController.view];
}

-(void) enableFrameUserInteractionAndDisableCationInteration:(BOOL) value Type:(NSString*)type
{
    BOOL isFoundObj = NO;
    
    for(UIView *view in self.backView.subviews)
    {
        if(view.tag == 2)// enable textview
        {
            for(CaptionView *obj in captionsArray)
            {
                obj.isCaptionMoveEnable = !value;
              
            }
            quoteResizableView.userInteractionEnabled = value;
            if([@"Text Box" isEqualToString:type])
                isFoundObj = YES;
        }
        if(view.tag == 3) // enable captions
        {
            for(CaptionView *obj in captionsArray)
            {
                obj.isCaptionMoveEnable = !value;
            }
            if([@"Caption" isEqualToString:type])
                isFoundObj = YES;
            view.userInteractionEnabled = !value;
        }
    }
    
    if(!isFoundObj)
    {
        if([@"Text Box" isEqualToString:type])
            [self missingObjAlert:type];
        else {
            [self missingObjAlert:type];
        }
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
		case 0: // Move
        {
            UIActionSheet *movableViewSheet = [[UIActionSheet alloc]initWithTitle:@"Move \"Text Box\" or \“Caption\”?" delegate:self cancelButtonTitle:@"Caption" destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Text Box",nil];
            
            [movableViewSheet showInView:self.view];
            
            movableViewSheet.tag = 3;
            [movableViewSheet release];
        }
           
            break;
		case 1: // Caption
            
            [self showCaptionView];
            quoteResizableView.userInteractionEnabled = NO;
            [self isShowTextControllerView:NO];
            
            break;
        case 2: // Text
            [captionViewController.view removeFromSuperview];
           
            for(CaptionView *obj in captionsArray)
            {
                obj.isCaptionMoveEnable = NO;
                
            }
          
            quoteResizableView.userInteractionEnabled = YES;
            [self isShowTextControllerView:!isShowTextController];
            break;
        default:
			break;
	}

}

- (void) shareButtonAction: (UIButton *) sender
{
    [captionViewController.view removeFromSuperview];
     [adView removeFromSuperview];
    
    NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
	[noteCenter addObserver:self selector:@selector(showAdwhirl) name:@"ShowAdwhirl" object:nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Sharing Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Save to photo album" otherButtonTitles:@"Facebook", @"Twitter", @"Tumblr", @"Email", nil];
    
    actionSheet.tag = 2;
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showFromBarButtonItem:shareBarButton animated:YES];
    [actionSheet release];
}

- (void)backButtonAction : (UIButton*) sender
{
    if(isSaveEditing)
        [self.navigationController popViewControllerAnimated:YES];
    else
    {
        UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"Alert !" message:@"Save image or lose editing.\n Want to save?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alertView.tag = 102;
        [alertView show];
        [alertView release];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 26)]autorelease];
    [backButton setImage:[UIImage imageNamed:@"mytravels.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backBarButton,nil];

    UIButton *shareButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 83, 26)]autorelease];
    [shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    shareBarButton = [[[UIBarButtonItem alloc] initWithCustomView:shareButton] autorelease];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:shareBarButton,nil];

    
    segmentCtrl.selectedSegmentIndex = 0;
    
    frameView = [[UIView alloc]initWithFrame:CGRectMake(0,29, 320, 475)];
    
    captionViewController = [[CaptionViewController alloc] initWithNibName:@"CaptionViewController" bundle:nil];
    captionViewController.superController = self;
    
    frameViewController = [[FrameViewController alloc] initWithNibName:@"FrameViewController" bundle:nil];
    frameViewController.view.frame = CGRectMake(0, 0, frameViewController.view.frame.size.width, frameViewController.view.frame.size.height);
    frameViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    
    textViewController = [[TextViewController alloc]init];
    textViewController.view.frame = CGRectMake(0, -50, textViewController.view.frame.size.width, textViewController.view.frame.size.height);
    textViewController.superController = self;
    [self.view addSubview:textViewController.view];
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 5, 250, 35)];
        
    textField.delegate = self;
    
    pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGuestureAction:)];
    [bgimageView addGestureRecognizer:pinchGesture];
    pinchGesture.delegate = self;

    captionsArray = [[NSMutableArray alloc]init];
    

    
}

- (void)applySrttingforTextCaption
{
    AppDelegate *appdelagte = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if(quoteResizableView)
    {
        quoteTextView.textColor = appdelagte.fontColor;
        quoteTextView.font = [UIFont fontWithName:appdelagte.fontName size:appdelagte.fontSize];
        
    }

    for(UIView *view in self.backView.subviews)
    {
        if(view.tag == 3) // enable captions
        {
            for(CaptionView *obj in captionsArray)
            {
                obj.textView.textColor = appdelagte.captionFontColo;
                obj.textView.font = [UIFont fontWithName:appdelagte.captionFontName size:appdelagte.captionFontSize];
            }
        }
    }

}

- (void)applySettings
{
    AppDelegate *appdelagte = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if(quoteResizableView)
    {
        quoteTextView.textColor = appdelagte.fontColor;
        quoteTextView.font = [UIFont fontWithName:appdelagte.fontName size:appdelagte.fontSize];

    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [self showAdwhirl];
 
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)snapShot
{
    UIImage *filterImage = nil;

    filterImage = [[ImageProccessing sharedInstance] convertViewIntoUIimage:backView];
    return filterImage;
}

#pragma mark - Action sheet Delgate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == 102)
    {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            superController.isPushtoMoreScreen = NO;
        }
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 2)
    {
       // [self.adBanner removeFromSuperview];
        
        switch (buttonIndex)
        {
                
            case 0: // Save to photo album
                [[ShareController sharedInstance] savedImageInAlbum:[self snapShot]];
                isSaveEditing = YES;
                break;
            case 1: // Facebook
                [[ShareController sharedInstance] shareWithFacebook:@"Check out what I did with MyTravels? iPhone app" viewController:self shareImage:[self snapShot]];
                break;
            case 2: // Twitter
                [[ShareController sharedInstance] shareWithTwitter:@"Check out what I did with MyTravels? iPhone app, #MyTravels?" viewController:self shareImage:[self snapShot]];
                break; 
            case 3: // Tumblr
                [[ShareController sharedInstance] shareWithTumblr:@"Check out what I did with MyTravels? iPhone app" viewController:self shareImage:[self snapShot]];
                break;
            case 4: // Email
                [[ShareController sharedInstance] shareWithMail:@"" :self :@"Check out what I did with MyTravels? iPhone app" attachent:[self snapShot]];
                break;
            case 5:
                [self showAdwhirl];
                
            default:
               
                break;
        }
      
            
    }
    if(actionSheet.tag == 3)
    {
        if(buttonIndex == 1)    //enable text move
        {
            [self enableFrameUserInteractionAndDisableCationInteration:YES Type:@"Text Box"];
            
        }
        else if(buttonIndex == 2)  // enable captions move
        {
            [self enableFrameUserInteractionAndDisableCationInteration:NO Type:@"Caption"];
            
        }
    }
}

#pragma  mark - Gesture

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
        if(isFrameApply)
        {
            CGAffineTransform oldTransform = CGAffineTransformIdentity;
            CGAffineTransform newTransform = CGAffineTransformScale(oldTransform,currentScale,currentScale);
            
            [frameImageView setTransform:newTransform];
            NSLog(@"pinch %f",currentScale);
        }
        
    }
}



#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
        UITouch *toucheA = [[event allTouches] anyObject];
    
        if (isKeyboardOpens) {
            isKeyboardOpens = NO;
           [quoteTextView.internalTextView resignFirstResponder];
            return;
        }
        if ([toucheA view] == currentlyEditingView) {
    
        }
        else
            [currentlyEditingView hideEditingHandles];
    
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"edit toch end");
}



#pragma mark - User resizable Delegate

- (void)userResizableViewDidBeginEditing:(UserResizableView *)userResizableView {
    
   [currentlyEditingView hideEditingHandles];
    currentlyEditingView = userResizableView;
    
}

- (void)userResizableViewDidEndEditing:(UserResizableView *)userResizableView {
    
    lastEditedView = userResizableView;
    
}

- (void) showKeyBoard
{
    if (!isKeyboardOpens) {
        isKeyboardOpens = YES;
        [quoteTextView.internalTextView becomeFirstResponder];
        return;
    }

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
 
    if ([currentlyEditingView hitTest:[touch locationInView:currentlyEditingView] withEvent:nil]) {
        return NO;
    }
    else
        [currentlyEditingView hideEditingHandles];
 
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (void)hideEditingHandles {
    // We only want the gesture recognizer to end the editing session on the last
    // edited view. We wouldn't want to dismiss an editing session in progress.
    [lastEditedView hideEditingHandles];
}


#pragma mark - Text View Delegate

-(void)resignTextView
{
    //[textView resignFirstResponder];
}

-(void)textViewBeginEditing:(UITextView*)textView{
    
    
}
-(void)textViewEndEditing:(UITextView*)textView{
    
            
}

- (BOOL)growingTextViewShouldBeginEditing:(GrowingTextView *)growingTextView{
    
    isKeyboardOpens = YES;
    
    
    [currentlyEditingView hideEditingHandles];
    currentlyEditingView = growingTextView.resizableView;
    
    [currentlyEditingView showEditing];
        return YES;

}


- (BOOL)growingTextViewShouldEndEditing:(GrowingTextView *)growingTextView{
    
    isKeyboardOpens = NO;
    
    lastEditedView = growingTextView.resizableView;
    
    return YES;
}

- (void)growingTextViewDidBeginEditing:(GrowingTextView *)growingTextView
{
    if([growingTextView.text isEqualToString:@"Your text here"])
        growingTextView.text = @"";

}

- (void)selectedFontSize:(int)size {
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.fontSize = size;
    
    selectedFont = [selectedFont fontWithSize:size];
    
    if(!selectedFont )
        selectedFont = [UIFont fontWithName:appDelegate.fontName size:appDelegate.fontSize];
  
    quoteTextView.font = selectedFont;
    
    CGPoint origin = CGPointMake(quoteResizableView.frame.origin.x, quoteResizableView.frame.origin.y);
    CGSize constraintSize;
    constraintSize.width = 800.0f;
    constraintSize.height = MAXFLOAT;
    
    CGSize textSize = [quoteTextView.text sizeWithFont:selectedFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect textFrame = CGRectMake(origin.x, origin.y, textSize.width+50, textSize.height+30);
    quoteResizableView.frame = textFrame;
    
}
- (void)selectedFont:(NSString*)fontName {
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.fontName = fontName;
    
    selectedFont = [UIFont fontWithName:fontName size:appDelegate.fontSize];
    quoteTextView.font = selectedFont;
    
}



- (void)selectedFontColor:(UIColor*)fontColor {
    
    AppDelegate *appDelegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.fontColor = fontColor;
    
    quoteTextView.textColor = fontColor;
}

- (BOOL)shouldAutorotate{
    
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    if(bgimageView.frame.size.width>bgimageView.frame.size.height)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    
    if(bgimageView.frame.size.width<bgimageView.frame.size.height)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if(bgimageView.frame.size.width>bgimageView.frame.size.height )
    {
        if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
            return YES;
    }
    
    if(bgimageView.frame.size.width<bgimageView.frame.size.height)
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
        adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];    // implement Adwhirl
        delegate.adView = [adView retain];
    }
    adView =delegate.adView;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        adView.frame = CGRectMake(0, -50, 320, 50);
    else
        adView.frame = CGRectMake(0, -50, 1024, 50);
    
    adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    
    
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
