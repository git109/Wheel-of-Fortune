//
//  WheelScrollViewViewController.h
//  WheelScrollView
//
//  Created by Shwet on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelScrollView.h"

@protocol WheelScrollViewDelegate <NSObject>
@optional
-(void)itemSelected:(NSInteger)index;

@end

@interface WheelScrollViewManager : UIView {

    NSArray * imageViewArray;
	CGAffineTransform initialTransform;  
    
	float currentValue;
    
    float rotationTotal;
    float previousAngle;
    WheelScrollView * wheelScrollView;
    NSInteger itemChangeIndex;
    NSInteger prevItemIndex;
    NSInteger itemIndexChangeDiff;
    
    NSMutableArray * initialTransformArray;
    
    BOOL isTapped;
    
    id <WheelScrollViewDelegate> delegate;
    UIImageView * bgImageView;
    UIImage * bgImage;
    
    NSMutableArray * itemsArray;
    BOOL zoomEffect;
    CGFloat zoomFactor;
    NSInteger angle;
    NSInteger noOfVisibleItems;
    NSInteger bufferElements;
    NSInteger wheelViewSize;
    NSInteger itemSize;
    NSInteger radiusOffset;
    BOOL isItemImageLandscape;
    UIImageView *overlayImageView;
    UIImage * overlayImage;
}

@property BOOL isItemImageLandscape;
@property NSInteger radiusOffset;
@property NSInteger wheelViewSize;
@property NSInteger itemSize;
@property CGFloat zoomFactor;
@property NSInteger angle;
@property NSInteger noOfVisibleItems;
@property NSInteger bufferElements;
@property BOOL zoomEffect;
@property (nonatomic, retain) NSMutableArray * itemsArray;
@property (nonatomic, retain) UIImage * bgImage;
@property (nonatomic, retain) UIImage * overlayImage;
@property CGAffineTransform initialTransform;
@property float currentValue;
-(id)initWithFrame:(CGRect)frame andDelegate:(id)_delegate;
-(void)loadView;
-(float)goodDegrees:(float)degrees;
-(void)setZoomOnItems;
-(void)resetZoomOnItems;
-(void)refreshInitialTransformArray;
-(void)resetInitialTransformArray:(NSInteger)indexChangeDiff;

@end
