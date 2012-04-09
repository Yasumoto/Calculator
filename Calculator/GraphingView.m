//
//  GraphingView.m
//  Calculator
//
//  Created by Joe Smith on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphingView.h"
#import "AxesDrawer.h"

@interface GraphingView()
- (void) setup;
@end

@implementation GraphingView

@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 0.90

- (CGFloat) scale {
    if (!_scale) {
        return DEFAULT_SCALE;
    }
    return _scale;
}

- (void) setup
{
    self.contentMode = UIViewContentModeRedraw;
}

- (void) awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint center;
    center.x = self.bounds.origin.x + self.bounds.size.width / 2;
    center.y = self.bounds.origin.y + self.bounds.size.height / 2;
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:center scale:self.scale];
    
    
}

@end
