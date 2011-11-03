//
//  WheelScrollViewViewController.m
//  WheelScrollView
//
//  Created by Shwet on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WheelScrollViewManager.h"

#define degreesToRadians(degrees) (M_PI * degrees / 180.0)
#define radiansToDegrees(radians) (radians * 180 / M_PI)

#define ANGLE_TOLERANCE 0.15f
#define ZOOM_DURATION 0.25f

static CGPoint delta;
static float deltaAngle;
static float currentAngle;

@implementation WheelScrollViewManager
@synthesize initialTransform,currentValue,bgImage;
@synthesize zoomFactor, angle, noOfVisibleItems,bufferElements,itemsArray,zoomEffect,wheelViewSize,itemSize,radiusOffset,isItemImageLandscape, overlayImage, circleCenter, wheelFace;

#pragma mark - View lifecycle
-(id)initWithFrame:(CGRect)frame andDelegate:(id)_delegate
{
    if((self = [super initWithFrame:frame]))
    {
        delegate = _delegate;
    }
    return self;
}

-(void)loadView
{
    bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    overlayImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:bgImageView];
    self.userInteractionEnabled = YES;
    currentValue = 0;
    currentAngle = 0;
    initialTransformArray = [[NSMutableArray alloc] init];
    
    //zoomEffect = NO;
    wheelScrollView = [[WheelScrollView alloc] initWithFrame:CGRectMake(0, 0, wheelViewSize, wheelViewSize) andRadiusOffset:radiusOffset andAngle:angle andItemsArray:itemsArray andNoOfVisibleItems:noOfVisibleItems andItemSize:itemSize andDelegate:self andZoomEffect:zoomEffect andZoomFactor:zoomFactor andBufferElements:bufferElements];
    [wheelScrollView setIsItemImageLandscape:isItemImageLandscape];
    wheelScrollView.center = circleCenter;
    //wheelScrollView.center = CGPointMake(160, 230);
    [wheelScrollView loadWheelView];
    for (float i = 0; i<[wheelScrollView.itemsImageViewArray count]; i++) {
        [initialTransformArray insertObject:[NSValue valueWithCGAffineTransform:((UIImageView *)[wheelScrollView.itemsImageViewArray objectAtIndex:i]).transform] atIndex:i];
    }
    [self addSubview:wheelScrollView];
    [self addSubview:overlayImageView];
    
    if(zoomEffect)
    {
        [self setZoomOnItems];
    }
}

-(void)setBgImage:(UIImage *)_bgImage
{
    bgImageView.image = _bgImage;
}

-(void)setOverlayImage:(UIImage *)_overlayImage
{
    overlayImageView.image = _overlayImage;
}

#pragma mark ===========UIViewDelegate touch events==========
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *thisTouch = [touches anyObject];
	delta = [thisTouch locationInView:self];
	
	float dx = delta.x  - wheelScrollView.center.x;
	float dy = delta.y  - wheelScrollView.center.y;
	deltaAngle = atan2(dy,dx); 
	
	//set an initial transform so we can access these properties through the rotations
	initialTransform = wheelScrollView.transform;
    if (zoomEffect) 
        [self resetZoomOnItems];
    [self refreshInitialTransformArray];
    
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 1 && [[touch view] isKindOfClass:[UIImageView class]]) {
        isTapped = YES;
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTapped = NO;
	UITouch *touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
	
	float dx = pt.x  - wheelScrollView.center.x;
	float dy = pt.y  - wheelScrollView.center.y;
	float ang = atan2(dy,dx);
    //NSLog(@"angle of rotaion of view %f", radiansToDegrees(ang));

	//do the rotation
	if (deltaAngle == 0.0) {
		deltaAngle = ang;
		initialTransform = wheelScrollView.transform;
        //[self refreshInitialTransformArray];
	}else
	{
		//from last move to now...
		float angleDif = deltaAngle - ang;
		
        //concatonate the transform with the angle difference
		CGAffineTransform newTrans = CGAffineTransformRotate(initialTransform, -angleDif);
		wheelScrollView.transform = newTrans;
        //[self refreshInitialTransformArray];
        for (int i = 0; i < [wheelScrollView.itemsImageViewArray count]; i++) {
            ((UIImageView *)[wheelScrollView.itemsImageViewArray objectAtIndex:i]).transform = CGAffineTransformRotate([(NSValue *)[initialTransformArray objectAtIndex:i] CGAffineTransformValue],angleDif);
        }
        currentValue = [self goodDegrees:radiansToDegrees(angleDif)];
        rotationTotal = rotationTotal + (radiansToDegrees(angleDif) - radiansToDegrees(previousAngle));
        previousAngle = angleDif;

        //if the scroll is fast... between items are skipped... default behaviour
        if ((angle / noOfVisibleItems - fmodf(rotationTotal, angle / noOfVisibleItems) <= ANGLE_TOLERANCE || 
             fmodf(rotationTotal, angle / noOfVisibleItems) <= ANGLE_TOLERANCE) && 
            (angle / noOfVisibleItems - fmodf(rotationTotal, angle / noOfVisibleItems) <= -ANGLE_TOLERANCE || 
             fmodf(rotationTotal, angle / noOfVisibleItems) >= -ANGLE_TOLERANCE)) {
            if(itemChangeIndex != (int)(rotationTotal / (angle / noOfVisibleItems)))
            {
                itemChangeIndex = rotationTotal / (angle / noOfVisibleItems);
                itemIndexChangeDiff = itemChangeIndex - prevItemIndex;
                prevItemIndex = itemChangeIndex;
                [wheelScrollView rePositionElements:itemIndexChangeDiff];
                [self resetInitialTransformArray:itemIndexChangeDiff];
            }            
        }
        else
            if(itemChangeIndex != (int)(rotationTotal / (angle / noOfVisibleItems)))
            {
                itemChangeIndex = rotationTotal / (angle / noOfVisibleItems);
                itemIndexChangeDiff = itemChangeIndex - prevItemIndex;
                prevItemIndex = itemChangeIndex;
                [wheelScrollView rePositionElements:itemIndexChangeDiff];
                [self resetInitialTransformArray:itemIndexChangeDiff];
            }
	}
}

-(void)resetInitialTransformArray:(NSInteger)indexChangeDiff
{
    NSInteger counter;
    if(indexChangeDiff < 0)
        counter = -indexChangeDiff;
    else
        counter = indexChangeDiff;
    NSInteger count = 0;
    if(counter >= 2)
    {
        NSLog(@"Counter 2");
    }
    while (count < counter) {
        if(indexChangeDiff < 0)
        {
            [initialTransformArray insertObject:(UIImageView *)[initialTransformArray objectAtIndex:([initialTransformArray count] - bufferElements - 1)] atIndex:0];
            [initialTransformArray removeLastObject]; 
            //((UIImageView *)[itemsImageViewArray objectAtIndex:0]).center = position;
        }
        else if(indexChangeDiff > 0)
        {
            [initialTransformArray addObject:(UIImageView *)[initialTransformArray objectAtIndex:bufferElements]];
            [initialTransformArray removeObjectAtIndex:0];            
            //((UIImageView *)[itemsImageViewArray objectAtIndex:[itemsImageViewArray count] - 1]).center = position;
        }
        count++;
    }
}

-(void)refreshInitialTransformArray
{
    [initialTransformArray removeAllObjects];
    
    for (int i = 0; i < [wheelScrollView.itemsImageViewArray count]; i++) {
        [initialTransformArray insertObject:[NSValue valueWithCGAffineTransform:((UIImageView *)[wheelScrollView.itemsImageViewArray objectAtIndex:i]).transform] atIndex:i];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    rotationTotal +=currentValue;
//    NSLog(@"%f",rotationTotal);
    previousAngle = 0;
	
	UITouch * touch = [touches anyObject];
    if ([touch tapCount] == 1 && [[touch view] isKindOfClass:[UIImageView class]]) {
        NSLog(@"%d", ((UIImageView *)[touch view]).tag);
        [delegate itemSelected:((UIImageView *)[touch view]).tag];
    }
    [self refreshInitialTransformArray];
    if(zoomEffect)
        [self setZoomOnItems];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
		
}

-(float) goodDegrees:(float)degrees
{
	float degOutput = degrees;
	while (degOutput >=360) {
		degOutput -= 360;
	}
	while (degOutput < 0) {
		degOutput += 360;
	}
	return degOutput;
}

-(void)setZoomOnItems
{
    
    NSInteger counter = 0;
    for(int i = ([wheelScrollView.itemsImageViewArray count] - noOfVisibleItems) / 2; i < (([wheelScrollView.itemsImageViewArray count] - noOfVisibleItems) / 2) + noOfVisibleItems;i++)
    {
        CGAffineTransform transform = [((NSValue *)[initialTransformArray objectAtIndex:i]) CGAffineTransformValue];
        if(counter <= noOfVisibleItems/2)
            transform = CGAffineTransformScale(transform, 1 + (counter/zoomFactor),1 + (counter/zoomFactor));
        else
            transform = CGAffineTransformScale(transform, 1 + ((noOfVisibleItems/2 - (counter - noOfVisibleItems/2))/zoomFactor),1 + ((noOfVisibleItems/2 - (counter - noOfVisibleItems/2))/zoomFactor));
        
        //transform = CGAffineTransformRotate(transform, 0);
//        if(counter <= noOfVisibleItems/2)            
//            transform = CGAffineTransformMakeScale(1 + (counter/zoomFactor),1 + (counter/zoomFactor));
//        else
//            transform = CGAffineTransformMakeScale(1 + ((noOfVisibleItems/2 - (counter - noOfVisibleItems/2))/zoomFactor),1 + ((noOfVisibleItems/2 - (counter - noOfVisibleItems/2))/zoomFactor));
        
        //transform = CGAffineTransformRotate(transform, 0);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:ZOOM_DURATION];
        ((UIImageView *)[wheelScrollView.itemsImageViewArray objectAtIndex:i]).transform = transform;
        [UIView commitAnimations];
        
        counter++;
    }
}


-(void)resetZoomOnItems
{
    
    NSInteger counter = 0;
    for(int i = ([wheelScrollView.itemsImageViewArray count] - noOfVisibleItems) / 2; i < (([wheelScrollView.itemsImageViewArray count] - noOfVisibleItems) / 2) + noOfVisibleItems;i++)
    {
        CGAffineTransform transform = [((NSValue *)[initialTransformArray objectAtIndex:i]) CGAffineTransformValue];
        transform = CGAffineTransformScale(transform, 1,1);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:ZOOM_DURATION];
        ((UIImageView *)[wheelScrollView.itemsImageViewArray objectAtIndex:i]).transform = transform;
        [UIView commitAnimations];
        
        counter++;
    }
}

@end
