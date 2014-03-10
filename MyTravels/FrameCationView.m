//
//  FrameCationView.m
//  MyTravels
//
//  Created by Rahul Jain on 01/12/12.
//  Copyright (c) 2012 Triffort Technologies. All rights reserved.
//

#import "FrameCationView.h"

@implementation FrameCationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (id)initWithImage:(UIImage *) image ImageSize:(CGSize) size
{
    
    self = [super initWithFrame:CGRectMake(0, 0, size.width,size.height)];
    if (self) {
        UIImageView *imageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        imageView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
    }
    return self; 

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
}


@end
