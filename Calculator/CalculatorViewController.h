//
//  HelloWorldViewController.h
//  Calculator
//
//  Created by Joe Smith on 11/25/11.
//  Copyright (c) 2012 bjoli.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphingView.h"

@interface CalculatorViewController : UIViewController <GraphingViewDataSource, UISplitViewControllerDelegate>
- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)enterPressed;
- (IBAction)undoPressed:(UIButton *)sender;
- (IBAction)graphProgram:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UILabel *enteredLabel;
@property (weak, nonatomic) IBOutlet UILabel *infixLabel;
@end
