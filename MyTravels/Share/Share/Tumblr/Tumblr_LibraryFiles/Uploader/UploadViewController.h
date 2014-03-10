//
//  UploadViewController.h
//  Tumblr
//
//  Created by Kashif Jilani on 12/30/12.
//  Copyright (c) 2012 Kashif Jilani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TumblrUploadr.h"
#import "SVProgressHUD.h"
@class ViewController;

@interface UploadViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,TumblrUploadrDelegate> {
    
    IBOutlet UITableView *blogTableView;
    
    NSString *blogString;
    NSMutableArray *blogArray;
    
    UIImage *tumblrImage;   // share image on tumblr
    NSString *tumblrCaption;    //caption for tumblr image
    
    UIActivityIndicatorView *acitvityIndicator;
    
    ViewController *superController;
}
@property (nonatomic, weak)  ViewController *superController;
@property (nonatomic, retain) NSString *blogString;
@property (nonatomic, retain) UIImage *tumblrImage;
@property (nonatomic, assign) NSString *tumblrCaption;

-(id)initWithData:(NSMutableArray *)dataArray;


@end
