//
//  WheelScrollViewDemoViewController.h
//  WheelScrollViewDemo
//
//  Created by Shwet on 07/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelScrollViewManager.h"

@interface WheelScrollViewDemoViewController : UIViewController <WheelScrollViewDelegate>
{
    WheelScrollViewManager * wheelScrollViewManager;
}
@end
