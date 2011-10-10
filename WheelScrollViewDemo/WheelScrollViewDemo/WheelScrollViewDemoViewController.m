//
//  WheelScrollViewDemoViewController.m
//  WheelScrollViewDemo
//
//  Created by Shwet on 07/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WheelScrollViewDemoViewController.h"

@implementation WheelScrollViewDemoViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)loadView
{
    [super loadView];
    wheelScrollViewManager = [[WheelScrollViewManager alloc] initWithFrame:self.view.bounds andDelegate:self];
    
    [wheelScrollViewManager setItemsArray:[NSMutableArray arrayWithObjects:@"1.jpg", @"2.jpg",@"3.jpg", @"4.jpg", @"5.jpg",@"6.jpg", @"7.jpg", nil]];
    [wheelScrollViewManager setAngle:65];
    [wheelScrollViewManager setNoOfVisibleItems:5];
    [wheelScrollViewManager setWheelViewSize:900];
    [wheelScrollViewManager setItemSize:50];
    [wheelScrollViewManager setZoomEffect:NO];
    [wheelScrollViewManager setZoomFactor:3.0];
    [wheelScrollViewManager setRadiusOffset:35];
    [wheelScrollViewManager setIsItemImageLandscape:NO];
    [wheelScrollViewManager loadView];
    [wheelScrollViewManager setBgImage:[UIImage imageNamed:@"background.jpg"]];
    //[wheelScrollViewManager setOverlayImage:[UIImage imageNamed:@"topOverlay.png"]];
    [self.view addSubview:wheelScrollViewManager];
    [self.view sendSubviewToBack:wheelScrollViewManager];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)itemSelected:(NSInteger)index
{
    
}

@end
