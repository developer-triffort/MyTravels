//
//  HomeViewController.h
//  MyTravels
//
//  Created by Mohd Muzammil on 30/10/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditingViewController;

@interface HomeViewController : UIViewController
{
    EditingViewController *editingViewController;
}
- (void)selectedBackground:(UIImage*)image;

@end
