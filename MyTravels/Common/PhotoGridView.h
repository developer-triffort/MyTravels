//
//  PhotoGridView.h
//  MyTravels
//
//  Created by Mohd Muzammil on 30/10/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoGridView : UIView {
    
    NSMutableArray *_images;
	NSMutableArray *_thumbs;
    NSMutableArray *_buttonArray;
    
	UIImage *_selectedImage;

    int imageSize;
    int selectedView;
    
    NSMutableArray *nameArray;
}

@property (nonatomic, retain) id classDelegate;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *thumbs;

@property (nonatomic, retain) NSMutableArray *buttonArray;
@property (nonatomic, retain)  NSMutableArray *nameArray;


@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, readwrite) int imageSize;


- (void)drawImageView;

@end
