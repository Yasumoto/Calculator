//
//  GraphingViewController.m
//  Calculator
//
//  Created by Joe Smith on 4/8/12.
//  Copyright (c) 2012 bjoli.com. All rights reserved.
//

#import "GraphingViewController.h"

@interface GraphingViewController ()
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@end

@implementation GraphingViewController

@synthesize graphingView = _graphingView;
@synthesize dataSource = _dataSource;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;

- (void) setGraphingView:(GraphingView *)graphingView {
    _graphingView = graphingView;
    self.graphingView.dataSource = self.dataSource;
    [self.graphingView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphingView action:@selector(pinch:)]];
    [self.graphingView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphingView action:@selector(pan:)]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.graphingView action:@selector(tap:)];
    tapGesture.numberOfTapsRequired = 3;
    [self.graphingView addGestureRecognizer:tapGesture];
}

- (void) setDataSource:(id<GraphingViewDataSource>)dataSource {
    _dataSource = dataSource;
    self.graphingView.dataSource = self.dataSource;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self handleSplitViewBarButtonItem:self.splitViewBarButtonItem];
    }
    return self;
}

- (void) handleSplitViewBarButtonItem:(UIBarButtonItem *) splitViewBarButtonItem {
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if(_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if(splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void) setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
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
