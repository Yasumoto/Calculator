//
//  HelloWorldViewController.h
//  Calculator
//
//  Created by Joe Smith on 11/25/11.
//  Copyright (c) 2012 bjoli.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelloWorldViewController : UIViewController
- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)enterPressed;
- (IBAction)test1Pressed:(UIButton *)sender;
- (IBAction)test2Pressed:(UIButton *)sender;
- (IBAction)testNilPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UILabel *enteredLabel;
@property (weak, nonatomic) IBOutlet UILabel *variablesLabel;
@end
