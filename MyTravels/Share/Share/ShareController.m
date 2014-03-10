//
//  ShareController.m
//  Cartoon Quiz
//
//  Created by Rahul Jain on 18/10/12.
//  Copyright (c) 2012 rahul kuamr jain. All rights reserved.
//

#import "ShareController.h"
#import <Social/Social.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "ViewController.h"


#define REQ_TOKEN @""

@interface ShareController(private)
- (void)internetSettingAlert;
@end

@implementation ShareController
@synthesize supercontroller;
@synthesize tumblrImage;
@synthesize viewController;

static ShareController *share;
static NSString * const kTumblrAuthenticationURL = @"http://www.tumblr.com/oauth/authorize";
static NSString * const kTumblrWriteURL = @"https://www.tumblr.com/api/write";


+ (ShareController *) sharedInstance
{
    if(!share)
        share = [[ShareController alloc] init];
    return share;
}
- (void) showAppirater
{
    [Appirater appLaunched];
}
- (void) shareWithTwitter : (NSString *) shareMessage viewController: (UIViewController*)viewcontroller shareImage:(UIImage *)image
{
    
    if([ShareController isNetworkAvilable])
    {
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            
            SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                
                [composeController dismissViewControllerAnimated:YES completion:nil];
                
                switch(result){
                    case SLComposeViewControllerResultCancelled:
                    default:
                    {
                        NSLog(@"Cancelled.....");
                        
                    }
                        break;
                    case SLComposeViewControllerResultDone:
                    {
                        [self showAppirater];
                       
                    }
                        break;
                }};

            
            [composeController setInitialText:shareMessage];
            [composeController addImage:image];
            [composeController addURL: [NSURL URLWithString:
                                    Itunes_URL]];
            [composeController setCompletionHandler:completionHandler];
        
            [viewcontroller presentViewController:composeController
                                         animated:YES completion:nil];
        
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops !" message:@"Twitter account is not configured to this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAdwhirl" object:nil];
    }
    else
    {
        [self internetSettingAlert];
    }

}



- (void) shareWithFacebook : (NSString *) shareMessage viewController:(UIViewController *)controller shareImage:(UIImage*)image
{
    if([ShareController isNetworkAvilable])
    {
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
        
            SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                
                [composeController dismissViewControllerAnimated:YES completion:nil];
                
                switch(result){
                    case SLComposeViewControllerResultCancelled:
                    default:
                    {
                        NSLog(@"Cancelled.....");
                        
                    }
                        break;
                    case SLComposeViewControllerResultDone:
                    {
                        [self showAppirater];
                       
                    }
                        break;
                }};
            
           
            [composeController addImage:image];
        
        
       
        
           NSString *msg = [NSString stringWithFormat:@"%@ \n %@",shareMessage,Itunes_URL];
            [composeController setInitialText:msg];
            
            [composeController setCompletionHandler:completionHandler];
            
            [controller presentViewController:composeController
                                     animated:YES completion:nil];
            
         
        
        /*
        NSArray *activityItems = @[shareMessage, image];
       // [composeController addURL: [NSURL URLWithString:@"https://itunes.apple.com/us/app/iframe-3d-photo-framing/id494613333?mt=8"]];
        
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
       
       // activityController.excludedActivityTypes = @[UIActivityTypeMail,UIActivityTypeMessage,UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact];
        
        [controller presentViewController:activityController
                           animated:YES completion:nil];
         */
        
        
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops !" message:@"Facebook account is not configured to this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAdwhirl" object:nil];
    }
    else
    {
        [self internetSettingAlert];
    }

}



- (void) savedImageInAlbum: (UIImage *)currentImage
{
    UIImageWriteToSavedPhotosAlbum(currentImage, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil); 

}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {  
	
    NSString *message;  
    NSString *title;  
    
    if (!error) {  
        title = NSLocalizedString(@"Saved", @"Saved");  
        message = NSLocalizedString(@"Image is successfully saved in your Photo Album.", @"Lasso Image is successfully saved in your Photo Album.");  
    } else {  
        title = NSLocalizedString(@"Error", @"Error");  
        message = [error description];  
    }  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title  
                                                    message:message  
                                                   delegate:nil  
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")  
                                          otherButtonTitles:nil];  
    [alert show];  
    [alert release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAdwhirl" object:nil];
}  

-(void) shareWithMail :(NSString *) shareMessage:(UIViewController *) selfController:(NSString *)subjectName attachent:(UIImage *)image
{
    if([ShareController isNetworkAvilable])
    {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if([mailClass canSendMail])
        {
        
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = (id)self;
    
  
            supercontroller = selfController;
    
            [picker setTitle:@"MyTravels?"];
            if([selfController isKindOfClass:NSClassFromString(@"ListItemViewController")])
                [picker setSubject:@"MyTravels?"];
            else
                [picker setSubject:subjectName];
    
            [picker setMessageBody:shareMessage isHTML:YES];
    
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
            [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"MyTravels?"];

   
    
            picker.navigationBar.tintColor = [UIColor blackColor];
            picker.navigationItem.title = @"MyTreavels?";
    
            [selfController presentViewController:picker animated:YES completion:nil];
            //[selfController presentModalViewController:picker animated:YES];
            [picker 
             release];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops !" message:@"Your email is not configured to this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }
    }
    else
    {
        [self internetSettingAlert];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            [self showAppirater];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
   // [controller dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
}

+ (BOOL) isNetworkAvilable
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    Reachability *internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    if(internetStatus)
        return YES;
    else
        return NO;
    
    return NO;
}

- (void) internetSettingAlert
{
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Alert !" message:@"No Internet connection is available at the moment. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [Alert show];
    [Alert release];
}
#pragma mark - Tumblr

- (void) shareWithTumblr : (NSString *) shareMessage viewController:(UIViewController *)controller shareImage:(UIImage*)image
{
    if([ShareController isNetworkAvilable])
    {
        NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
        [noteCenter addObserver:self selector:@selector(showAppirater) name:@"showAppirater" object:nil];
        
        viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        viewController.tumblrImage = image;
        
       NSString *msg = [NSString stringWithFormat:@"%@ \n %@",shareMessage,Itunes_URL];
        
        viewController.tumblrCaption = [msg copy];
        [controller.navigationController presentViewController:viewController animated:YES completion:nil];
      
        
    }
    else
    {
        [self internetSettingAlert];
    }

}

@end
