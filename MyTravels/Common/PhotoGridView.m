//
//  PhotoGridView.m
//  MyTravels
//
//  Created by Mohd Muzammil on 30/10/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import "PhotoGridView.h"
#import "HomeViewController.h"
#import "UIImageExtras.h"
#import <QuartzCore/QuartzCore.h>
#import <RevMobAds/RevMobAds.h>

#define NUMBER_OF_COLOUM 1

@implementation PhotoGridView

@synthesize images = _images;
@synthesize thumbs = _thumbs;
@synthesize selectedImage = _selectedImage;
@synthesize buttonArray = _buttonArray;
@synthesize nameArray;
@synthesize imageSize;
@synthesize classDelegate;

- (BOOL)hasFourInchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height > 500.0);
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _images =  [[NSMutableArray alloc] init];
		_thumbs =  [[NSMutableArray alloc] init];
        _buttonArray = [[NSMutableArray alloc] init];
       
        /*
        nameArray = [[NSMutableArray alloc] initWithObjects:@"DC Capitol Rotunda",@"NYC Times Square",@"Maui, Hawaii",@"Beverly Hills, California",@"Grand Canyon",@"Bottom of the Ocean Shark",@"Hawaii",@"Brooklyn Bridge",@"Oklahoma Tornado",@"Las Vegas, Nevada",@"San Francisco Golden Gate",@"Statue of Liberty",@"NYC Radio City Music Hall",@"Pensacola, Florida Heart",@"Niagara Falls",@"NYC Grand Central",@"Alaskan Bear",@"DC Capitol",@"Beach, Palm Trees",@"NYC 5th & Broadway",@"Mount Rushmore",@"St. Louis Missouri Arch",@"Philadelphia Liberty Bell",@"Old Faithful, Yellow Stone Park",@"Minnesota Birches in Snow",@"DC, National Monument",@"Appalachian Trail",@"Arizona Desert",@"Route 66",@"DC Lincoln Memorial",@"DC, Martin Luther King",@"Vacation on the Beach", nil];@"NYC Times Square",@"Maui, Hawaii",
         */
       
        nameArray = [[NSMutableArray alloc] initWithObjects:@"Hawaii",@"Brooklyn Bridge",@"Oklahoma Tornado",@"Las Vegas, Nevada",@"San Francisco Golden Gate",@"Statue of Liberty",@"Beach, Palm Trees",@"NYC 5th & Broadway",@"Mount Rushmore",@"Kansas Sunflowers",@"Philadelphia Liberty Bell",@"Tropical Beach",@"Minnesota Birches in Snow",@"DC, National Monument",@"Appalachian Trail",@"Kauai, Hawaii",@"Route 66",@"DC, Lincoln Memorial",@"Sailing",@"Rainbow's End",@"DC Capitol",@"Beverly Hills, California",@"Grand Canyon",@"Bottom of the Ocean Shark", nil];
        
        NSLog(@"number of image count %d", [nameArray count]);

        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
-(UIImage*)convertViewIntoUIimage : (UIView*)viewImage
{
    UIGraphicsBeginImageContext(viewImage.bounds.size);
    [viewImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)drawImageView {
	
	// Create view
    imageSize = 150;
    
	UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
	
    // UIImage * backgroundImage = [UIImage imageNamed:@"AppBackgroundImage.png"];
	//UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    view.backgroundColor =  [UIColor blackColor];
    
	int row = 0;
	int column = 0;
	
    int img = 0;

	for(int i = 1; i < 25; ++i) {
        
        if (img >= 24 ){
            img = 0;
        }
        img++;
         
        UIImage *thumb = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[nameArray objectAtIndex:img-1]]];
        
        thumb = [thumb scaleImage:thumb toResolution:240]; //  ratina size
        // thumb = [thumb imageByScalingAndCroppingForSize:CGSizeMake(imageSize, imageSize)];
        
        UIImageView *thumbImageView = [[UIImageView alloc] initWithImage:thumb];
        thumbImageView.frame = CGRectMake(0, 0, thumb.size.width/2, thumb.size.height/2);
        
        thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
		UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(column*imageSize, row*imageSize, imageSize, imageSize);
		[button setImage:[self convertViewIntoUIimage:thumbImageView] forState:UIControlStateNormal];
        
        
		[button addTarget:self
				   action:@selector(buttonClicked:)
		 forControlEvents:UIControlEventTouchUpInside];
                
		button.tag = img;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(column*imageSize, (row*imageSize)+imageSize-17, imageSize, 25)];
        NSLog(@"ImageName %d",img);
		label.text = [nameArray objectAtIndex:img-1];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:9];
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:button];
        [view addSubview:label];
        
        
        [_buttonArray addObject:button];
		
        if (column == NUMBER_OF_COLOUM) {
            column = 0;
            row++;
        } else {
            column++;
        }
	}
    
	[view setContentSize:CGSizeMake(320, (row*imageSize) + 50)];
	view.scrollEnabled = YES;
    view.pagingEnabled = NO;
    [self addSubview:view];
	
    //[view release];
	
}

- (IBAction)buttonClicked:(id)sender {
	
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    
    NSString *imageName = [NSString stringWithFormat:@"%@", [nameArray objectAtIndex:tag-1]];
    if([self hasFourInchDisplay])
    {
        imageName = [NSString stringWithFormat:@"%@-568h",imageName];
    }
    UIImage *bg = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imageName]];
   
    [self.classDelegate selectedBackground:bg];
    
   // [[RevMobAds session] showFullscreen];
    
}

- (IBAction)cancel:(id)sender {
	
    self.selectedImage = nil;
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
