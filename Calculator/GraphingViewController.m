//
//  GraphingViewController.m
//  Calculator
//
//  Created by Joe Smith on 4/8/12.
//  Copyright (c) 2012 bjoli.com. All rights reserved.
//

#import "GraphingViewController.h"

@interface GraphingViewController ()

@end

@implementation GraphingViewController

@synthesize graphingView = _graphingView;
@synthesize dataSource = _dataSource;

- (void) setGraphingView:(GraphingView *)graphingView {
    _graphingView = graphingView;
    self.graphingView.dataSource = self.dataSource;
    [self.graphingView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphingView action:@selector(pinch:)]];
    [self.graphingView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphingView action:@selector(pan:)]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.graphingView action:@selector(tap:)];
    tapGesture.numberOfTapsRequired = 3;
    [self.graphingView addGestureRecognizer:tapGesture];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
