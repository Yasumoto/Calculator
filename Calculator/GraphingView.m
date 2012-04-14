//
//  GraphingView.m
//  Calculator
//
//  Created by Joe Smith on 4/8/12.
//  Copyright (c) 2012 bjoli.com. All rights reserved.
//

#import "GraphingView.h"
#import "AxesDrawer.h"

@interface GraphingView()
- (void) setup;
@end

@implementation GraphingView

@synthesize scale = _scale;
@synthesize dataSource = _dataSource;
@synthesize center = _center;
@synthesize drawingLine = _drawingLine;

#define DEFAULT_SCALE 20

- (CGFloat) scale {
    if (!_scale) {
        return DEFAULT_SCALE;
    }
    return _scale;
}

-(void) setCenter:(CGPoint)center {
    if ((center.x != _center.x) ||
        (center.y != _center.y)) {
        _center.x = center.x;
        _center.y = center.y;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setFloat:center.x forKey:@"centerX"];
        [userDefaults setFloat:center.y forKey:@"centerY"];
        [self setNeedsDisplay];
    }
}

-(void) setScale:(CGFloat)scale {
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setFloat:self.scale forKey:@"scale"];
    }
}

- (void) setup
{
    self.contentMode = UIViewContentModeRedraw;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults floatForKey:@"centerX"]) {
        self.center = CGPointMake([userDefaults floatForKey:@"centerX"],
                                  [userDefaults floatForKey:@"centerY"]);
    }
    else {
        self.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2,
                                  self.bounds.origin.y + self.bounds.size.height / 2);
    }
    if ([userDefaults floatForKey:@"scale"]) {
        self.scale = [userDefaults floatForKey:@"scale"];
    }
}

- (void) awakeFromNib
{
    [self setup];
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture {
    if((gesture.state == UIGestureRecognizerStateChanged) ||
       (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

-(void)pan:(UIPanGestureRecognizer *)gesture {
    if((gesture.state == UIGestureRecognizerStateChanged) ||
       (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint currentCenter = self.center;
        CGPoint translation = [gesture translationInView:self];
        self.center = CGPointMake(currentCenter.x + translation.x, currentCenter.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self];
    }
}

-(void)tap:(UITapGestureRecognizer *)gesture {
    if((gesture.state == UIGestureRecognizerStateChanged) ||
       (gesture.state == UIGestureRecognizerStateEnded)) {
        self.center = [gesture locationInView:self];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)drawGraphWithLines {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor redColor] setStroke];
    CGContextBeginPath(context);
    CGFloat startX = self.bounds.origin.x - self.center.x;
    CGContextMoveToPoint(context, startX, [self.dataSource PointYToPlotForXValue:startX forGraphingView:self]);
    for (CGFloat x = self.bounds.origin.x+1.0; x < self.bounds.origin.x + self.bounds.size.width; x += 1.0) {
        CGFloat plotPoint = (x - self.center.x)/self.scale;
        CGFloat y = [self.dataSource PointYToPlotForXValue:plotPoint forGraphingView:self];
        CGContextAddLineToPoint(context, x, self.center.y - self.scale * y);
    }
    CGContextStrokePath(context);
}

- (void)drawGraphWithDots {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blueColor] setStroke];
    CGContextBeginPath(context);
    CGFloat startX = self.bounds.origin.x - self.center.x;
    CGContextMoveToPoint(context, startX, [self.dataSource PointYToPlotForXValue:startX forGraphingView:self]);
    for (CGFloat x = self.bounds.origin.x+1.0; x < self.bounds.origin.x + self.bounds.size.width; x += 1.0) {
        CGFloat plotPoint = (x - self.center.x)/self.scale;
        CGFloat y = [self.dataSource PointYToPlotForXValue:plotPoint forGraphingView:self];
        CGContextAddLineToPoint(context, x, self.center.y - self.scale * y);
    }
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect
{
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.center scale:self.scale];
    if (self.drawingLine) {
        [self drawGraphWithLines];
    }
    else {
        [self drawGraphWithDots];
    }

}

@end
