//
//  GraphingViewController.h
//  Calculator
//
//  Created by Joe Smith on 4/8/12.
//  Copyright (c) 2012 bjoli.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphingView.h"

@interface GraphingViewController : UIViewController <SplitViewBarButtonItemPresenter>
@property (nonatomic, weak) IBOutlet GraphingView *graphingView;
@property (nonatomic, weak) IBOutlet id <GraphingViewDataSource> dataSource;
@end
