//
//  GraphingView.h
//  Calculator
//
//  Created by Joe Smith on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphingView;

@protocol GraphingViewDataSource
- (float) PointYToPlotForXValue:(float) x forGraphingView:(GraphingView *)sender;
@end

@interface GraphingView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic, weak) IBOutlet id <GraphingViewDataSource> dataSource;

-(void) pinch:(UIPinchGestureRecognizer *) gesture;
-(void) pan:(UIPanGestureRecognizer *) gesture;

@end
