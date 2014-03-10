//
//  FontViewController.m
//  Quotify
//
//  Created by Rahul Jain on 18/10/12.
//  Copyright (c) 2012 rahul kuamr jain. All rights reserved.
//
#import "FontViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "FrameCaptionViewController.h"

#define STEPPER_LANDSCAPE_FRAME_IPHONE5 CGRectMake(448, 10, 80, 35)
#define COLOR_LANDSCAPE_FRAME_IPHONE5 CGRectMake(483, 5, 45, 35)

@implementation FontViewController


@synthesize selectedFont;
@synthesize currentColor;
@synthesize colorView;
@synthesize stepper;
@synthesize fontSize, fontName;
@synthesize sampleText;
@synthesize superController;
@synthesize fontArray;
@synthesize isCaptioning;
@synthesize textView;

- (BOOL)hasFourInchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height > 500.0);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        self.fontName = appDelegate.fontName;
        self.fontSize = [NSString stringWithFormat:@"%d", appDelegate.fontSize];
        self.currentColor = appDelegate.fontColor;
        
        self.colorView.backgroundColor = self.currentColor;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)selectedBackgroundColor:(UIColor*)color {
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.currentColor = [UIColor colorWithCGColor:color.CGColor];
    if(isCaptioning)
        appDelegate.captionFontColo = self.currentColor;
    else
        [superController selectedFontColor:self.currentColor];
    
    [colorView setBackgroundColor:self.currentColor];
    
    [self.sampleText setTextColor:self.currentColor];
    
    
    
}

- (void)stepperAction:(UIStepper*)sender {
    
    double value = [sender value];
    
    self.fontSize = [NSString stringWithFormat:@"%d", (int)value];
        
    self.selectedFont = [UIFont fontWithName:self.fontName size:value];
    
    [self.sampleText setFont:self.selectedFont];
    
    [superController selectedFontSize:(int)value];
    
    tableCell.textLabel.text = [NSString stringWithFormat:@"Font size # %@", fontSize];
    
    [fontTableView reloadData];
}

- (UIView*)colorView {
    
    UIView *view = [[UIView alloc] initWithFrame:COLOR_PORTRAIT_FRAME];
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) 
    {       
        view.frame = COLOR_LANDSCAPE_FRAME; 
    } 

    view.layer.cornerRadius = 5;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 2;
    
    view.backgroundColor = self.currentColor;
    view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    
    return view;
}

- (UIStepper*)fontStepper {
    
    UIStepper *step = [[UIStepper alloc] initWithFrame:STEPPER_PORTRAIT_FRAME];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //step.value = appDelegate.fontSize;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) 
    {
        step.frame = STEPPER_LANDSCAPE_FRAME;
    }
    
    step.maximumValue = 50.0;
    step.minimumValue = 10.0;
  
    if(isCaptioning)
        step.value = appDelegate.captionFontSize;
    else
        step.value = appDelegate.fontSize;
    
    [step addTarget:self action:@selector(stepperAction:) forControlEvents:UIControlEventValueChanged];
    
    step.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    
    return step;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (section == 2) {
            return @"\nFont Style";
        }
    }
    else {
        
        if (section == 2) {
            return @"Font Style";
        }
    }

    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.imageView.image = [UIImage imageNamed:@""];
        
        if (!self.stepper) {
            
            self.stepper = [self fontStepper];
            
            [cell addSubview:self.stepper];
        }
        
        if ([fontSize intValue] > 0) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"Font size # %@", fontSize];
        }
        
        tableCell = cell;
        
    }
    
    if (indexPath.section == 1) {
        
        cell.textLabel.text = @"Text Color";
        
        if (!colorView) {

            colorView = [self colorView];
            
            [colorView setBackgroundColor:self.currentColor];
            
            [cell.contentView addSubview:colorView];
        }
        
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        
        ColorPickerController *colorPickerViewController = 
        [[ColorPickerController alloc] initWithNibName:@"ColorPickerController" bundle:nil];
        colorPickerViewController.view.frame = CGRectMake(0, 0, 320, 440);
        colorPickerViewController.fontViewController = self;
        colorPickerViewController.effectsViewController = nil;
        
        [self.navigationController pushViewController:colorPickerViewController animated:YES];
        
        [colorPickerViewController release];
    }
}


-(void)getFontName{
    
    NSArray *familyNames = [UIFont familyNames];
    
    fontArray = [[NSMutableArray alloc] init];
    NSMutableArray *data = [[[NSMutableArray alloc] init] autorelease];
    
    for( NSString *familyName in familyNames ){
        
        NSMutableArray* familyContents = [NSMutableArray array];
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName1 in fontNames ){
            [familyContents addObject:fontName1];
        }
        
        [data addObject:[NSDictionary dictionaryWithObjectsAndKeys:familyContents, @"fonts", familyName, @"name", nil]];
    }
    // sort families by name:
    [data sortUsingComparator:(NSComparator)^(id obj1, id obj2) {
        return [[obj1 valueForKey:@"name"] caseInsensitiveCompare:[obj2 valueForKey:@"name"]];
        
    }];
    
    
    for (int n = 0; n<[data count]; n++) {
        
        NSArray *arr = [[data objectAtIndex:n] objectForKey:@"fonts"];
        
        for (int k = 0; k<[arr count]; k++) {
            
            [fontArray addObject:[arr objectAtIndex:k]];
        }
    }
}
    
#pragma mark - Picker Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *str = [fontArray objectAtIndex:row];
    
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
        
    NSString *font = [fontArray objectAtIndex:row];
    
    self.fontName = font;
    
    self.selectedFont = [UIFont fontWithName:self.fontName size:[self.fontSize intValue]];
    
    [self.sampleText setFont:self.selectedFont];
  
    if(!isCaptioning)
        [superController selectedFont:font];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [fontArray count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
   
    UIView * fontnameView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 50)] autorelease];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 270, 30)] autorelease];
    
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
   
    NSString *font = [fontArray objectAtIndex:row];
    
    [label setFont:[UIFont fontWithName:font size:16.0]];
    [label setText:font];
    
    [fontnameView addSubview:label];
    
    return fontnameView;        

}

- (void)saveButton:(id)sender {

    if(([superController.captionsArray count]>=1 && !superController.quoteResizableView) || ([superController.captionsArray count]==0 && superController.quoteResizableView ) ||([superController.captionsArray count]==0 && !superController.quoteResizableView))
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [[NSUserDefaults standardUserDefaults] setValue:self.fontName forKey:Cap_Font_Name];
        [[NSUserDefaults standardUserDefaults] setInteger:[self.fontSize intValue] forKey:Cap_Font_Size];
        
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:self.currentColor];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:Cap_Font_Color];
        
        if(isCaptioning)
        {
            NSLog(@"font name %@",self.fontName);
                
            appDelegate.captionFontName = self.fontName;
            appDelegate.captionFontSize = [self.fontSize intValue];
            appDelegate.captionFontColo = self.currentColor;
                
            textView.font = [UIFont fontWithName:self.fontName size:[self.fontSize intValue]];
            textView.textColor = self.currentColor;
                
        }
        else
        {
            appDelegate.fontName = self.fontName;
            appDelegate.fontSize = [self.fontSize intValue];
            appDelegate.fontColor = self.currentColor;
                
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Do you want the caption and text box to have the same color and size of fonts?" delegate:self cancelButtonTitle:@"Same" otherButtonTitles:@"Different", nil];
        alertView.tag = 101;
        [alertView show];
        [alertView release];

    }
}

- (void)cancelButton:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Alertview delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:self.currentColor];

        if(buttonIndex == 1)
        {
                        
            if(isCaptioning)
            {
                [[NSUserDefaults standardUserDefaults] setValue:self.fontName forKey:Cap_Font_Name];
                [[NSUserDefaults standardUserDefaults] setInteger:[self.fontSize intValue] forKey:Cap_Font_Size];
                
               
                [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:Cap_Font_Color];
                
                appDelegate.captionFontName = self.fontName;
                appDelegate.captionFontSize = [self.fontSize intValue];
                appDelegate.captionFontColo = self.currentColor;
                
                textView.font = [UIFont fontWithName:self.fontName size:[self.fontSize intValue]];
                textView.textColor = self.currentColor;
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setValue:self.fontName forKey:Font_Name];
                [[NSUserDefaults standardUserDefaults] setInteger:[self.fontSize intValue] forKey:Font_Size];
                
              
                [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:Font_Color];

                
                appDelegate.fontName = self.fontName;
                appDelegate.fontSize = [self.fontSize intValue];
                appDelegate.fontColor = self.currentColor;
            
            }
 

        }
        else if(buttonIndex ==0)
        {            
            [[NSUserDefaults standardUserDefaults] setValue:self.fontName forKey:Cap_Font_Name];
            [[NSUserDefaults standardUserDefaults] setInteger:[self.fontSize intValue] forKey:Cap_Font_Size];
            
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:Cap_Font_Color];
            [[NSUserDefaults standardUserDefaults] setValue:self.fontName forKey:Font_Name];
            [[NSUserDefaults standardUserDefaults] setInteger:[self.fontSize intValue] forKey:Font_Size];
            
            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:Font_Color];

            appDelegate.captionFontName = self.fontName;
            appDelegate.captionFontSize = [self.fontSize intValue];
            appDelegate.captionFontColo = self.currentColor;
            
            appDelegate.fontName = self.fontName;
            appDelegate.fontSize = [self.fontSize intValue];
            appDelegate.fontColor = self.currentColor;
                        
            [superController applySrttingforTextCaption];
        }
       
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
        
   
}
- (void)viewDidAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 430);

    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        if([self hasFourInchDisplay])
        {
            self.stepper.frame = STEPPER_LANDSCAPE_FRAME_IPHONE5;
            colorView.frame = COLOR_LANDSCAPE_FRAME_IPHONE5;
        }
        else
        {
            self.stepper.frame = STEPPER_LANDSCAPE_FRAME;
            colorView.frame = COLOR_LANDSCAPE_FRAME;
        }
    }

    
    if(isCaptioning)
    {
        self.fontName = appDelegate.captionFontName;
        self.fontSize = [NSString stringWithFormat:@"%d", appDelegate.captionFontSize];
        self.currentColor = appDelegate.captionFontColo;
    
    }
    else
    {
        self.fontName = appDelegate.fontName;
        self.fontSize = [NSString stringWithFormat:@"%d", appDelegate.fontSize];
        self.currentColor = appDelegate.fontColor;
        
        self.colorView.backgroundColor = self.currentColor;

    }
    
    [fontTableView reloadData];

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.contentSizeForViewInPopover = CGSizeMake(320, 430);
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.title = @"Font";
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButton:)] autorelease];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButton:)]autorelease];
 
        UIColor *bgColor = [UIColor groupTableViewBackgroundColor];

        [fontTableView setBackgroundView:nil];
        [fontTableView setBackgroundColor:bgColor];
    }
    
    
    [self getFontName];
    
    [fontPicker reloadAllComponents];
    
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
   // stepper.value = appDelegate.fontSize;
    if(isCaptioning)
    {
        [sampleText setTextColor:appDelegate.captionFontColo];
        [sampleText setFont:[UIFont fontWithName: appDelegate.captionFontName size:appDelegate.captionFontSize]];
    }
    else
    {
        [sampleText setTextColor:appDelegate.fontColor];
        [sampleText setFont:[UIFont fontWithName: appDelegate.fontName size:appDelegate.fontSize]];
    }
    
    [sampleText setTextAlignment:NSTextAlignmentCenter];
    //int size = [self.fontSize intValue];
    
    [sampleText setText:@"This is sample text"];
    [sampleText setBackgroundColor:[UIColor clearColor]];
    
    

    
    [fontTableView reloadData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        if([self hasFourInchDisplay])
        {
            self.stepper.frame = STEPPER_LANDSCAPE_FRAME_IPHONE5;
            colorView.frame = COLOR_LANDSCAPE_FRAME_IPHONE5;
        }
        else
        {
            self.stepper.frame = STEPPER_LANDSCAPE_FRAME;
            colorView.frame = COLOR_LANDSCAPE_FRAME;
        }
            return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        self.stepper.frame = STEPPER_PORTRAIT_FRAME;
        colorView.frame = COLOR_PORTRAIT_FRAME;
            
        return UIInterfaceOrientationMaskPortrait;
    }
   

    return UIInterfaceOrientationMaskPortrait;// | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    
    AppDelegate *appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIImage *bgImage = appdel.userImage;
    
    if(bgImage.size.width>bgImage.size.height )
    {
        if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            self.stepper.frame = STEPPER_LANDSCAPE_FRAME;
            colorView.frame = COLOR_LANDSCAPE_FRAME;

            return YES;
        }
    }
    
    if(bgImage.size.width<bgImage.size.height)
    {
        if(interfaceOrientation == UIInterfaceOrientationPortrait)
        {
            self.stepper.frame = STEPPER_PORTRAIT_FRAME;
            colorView.frame = COLOR_PORTRAIT_FRAME;

            return YES;
        }
    }
    
    return NO;

}

@end
