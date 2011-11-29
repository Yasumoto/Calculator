//
//  HelloWorldViewController.m
//  Calculator
//
//  Created by Joe Smith on 11/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldViewController.h"
#import "CalculatorBrain.h"

@interface HelloWorldViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation HelloWorldViewController

@synthesize displayLabel = _displayLabel;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}


- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.displayLabel.text = [self.displayLabel.text stringByAppendingString:digit];
    } else {
        self.displayLabel.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.displayLabel.text  = resultString;
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.displayLabel.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}
@end
