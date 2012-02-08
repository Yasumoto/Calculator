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
@property (nonatomic, strong) NSDictionary *testVariableValues;
@end

@implementation HelloWorldViewController
@synthesize enteredLabel = _enteredLabel;

@synthesize displayLabel = _displayLabel;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    self.enteredLabel.text = [self.enteredLabel.text stringByAppendingFormat:@"%@", sender.currentTitle];
    if ([digit isEqualToString:@"."]) {
        // This isn't the right behavior! You need to get the userIsInTheMiddleOfEnteringANumber
        // stuff correct. You are totally ignoring whether the user is in the middle by
        // keeping the decimal stuff out of the below if/else segments.
        // Take the below three lines and schnag them out, split them out into the right sections
        // glhfdd broski. time for bedtime
        // <3 12/12/11
        if (self.userIsInTheMiddleOfEnteringANumber) {
            if ([self.displayLabel.text rangeOfString:@"."].location == NSNotFound) {
                self.displayLabel.text = [self.displayLabel.text stringByAppendingString:digit];
                self.userIsInTheMiddleOfEnteringANumber = YES;
            }
        }
        else {
            //if ([self.displayLabel.text rangeOfString:@"."].location == NSNotFound) {
            self.displayLabel.text = [NSString stringWithFormat:@"0%@", digit];
            self.userIsInTheMiddleOfEnteringANumber = YES;
            //}
        }
    } else {
        if (self.userIsInTheMiddleOfEnteringANumber) {
            
            self.displayLabel.text = [self.displayLabel.text stringByAppendingString:digit];
        } else {
            self.displayLabel.text = digit;
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    [self.brain performOperation:sender.currentTitle];
    double result = [[self.brain class] runProgram:[self.brain program] usingVariableValues:self.testVariableValues];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.displayLabel.text  = resultString;
    if ([sender.currentTitle  isEqualToString:@"C"]) {
        self.enteredLabel.text = @"";
        self.testVariableValues = [[NSDictionary alloc] init];
    }
    else {
        self.enteredLabel.text = [self.enteredLabel.text stringByAppendingFormat:@"%@ ", sender.currentTitle];
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[NSNumber numberWithDouble:[self.displayLabel.text doubleValue]]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.enteredLabel.text = [self.enteredLabel.text stringByAppendingFormat:@" "];
}

- (IBAction)test1Pressed:(UIButton *)sender {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithFloat:1.0], @"x",
     [NSNumber numberWithFloat:2.0], @"a",
     [NSNumber numberWithFloat:3.0], @"b", nil];
}

- (IBAction)test2Pressed:(UIButton *)sender {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithFloat:-10.0], @"x",
                               [NSNumber numberWithFloat:9001.0], @"a", nil];
}

- (IBAction)testNilPressed:(UIButton *)sender {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               nil, @"x",
                               nil, @"a",
                               nil, @"b", nil];
}

- (void)viewDidUnload {
    [self setEnteredLabel:nil];
    [super viewDidUnload];
}
@end
