//
//  WheelScrollView.h
//  WheelScrollView
//
//  Created by Shwet on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelScrollViewManager.h"
enum WheelFace
{
    kWheelFaceUp,
    kWheelFaceLeft,
    kWheelFaceDown,
    kWheelFaceRight
};

@interface WheelScrollView : UIView{
    NSInteger radius;
    NSInteger radiusOffset;
    CGFloat angle;
    NSMutableArray * itemsArray;
    NSInteger noOfVisibleItems;
    NSMutableArray * itemsImageViewArray;
    NSInteger size;
    id delegate;
    BOOL zoomEffect;
    UIView * collisionView;
    NSTimer * collisonTimer;
    NSInteger bufferElements;
    
    float currentValue;    
    float rotationTotal;
    float previousAngle;
    NSInteger itemChangeIndex;
    NSInteger upperBoundIndex;
    NSInteger lowerBoundIndex;
    
    CGRect frame;
    CGFloat zoomFactor; 
    BOOL isItemImageLandscape;
}

@property BOOL isItemImageLandscape;
@property (nonatomic, retain) NSMutableArray * itemsImageViewArray;
@property (nonatomic, retain) UIView * collisionView;

-(id)initWithFrame:(CGRect)_frame andRadiusOffset:(NSInteger)_radiusOffset andAngle:(CGFloat)_angle andItemsArray :(NSMutableArray *)_itemsArray andNoOfVisibleItems:(NSInteger)_noOfVisibleItems andItemSize:(NSInteger)_size andDelegate:(id)_delegate andZoomEffect:(BOOL)_zoomEffect andZoomFactor:(CGFloat)_zoomFactor andBufferElements:(NSInteger)_bufferElements;
-(void)loadWheelView;
-(void)rePositionElements:(NSInteger)indexChangeDiff;
-(CGPoint)getInitialPosition;
@end
