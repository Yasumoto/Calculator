//
//  HelloWorldViewController.m
//  Calculator
//
//  Created by Joe Smith on 11/25/11.
//  Copyright (c) 2012 bjoli.com. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController
@synthesize enteredLabel = _enteredLabel;
@synthesize infixLabel = _infixLabel;

@synthesize displayLabel = _displayLabel;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (NSDictionary *)testVariableValues {
    if (!_testVariableValues) {
        _testVariableValues = [[NSDictionary alloc] initWithObjectsAndKeys:@"x", @"0", nil];
    }
    return _testVariableValues;
}

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if ([digit isEqualToString:@"."]) {
        if (self.userIsInTheMiddleOfEnteringANumber) {
            if ([self.displayLabel.text rangeOfString:@"."].location == NSNotFound) {
                self.displayLabel.text = [self.displayLabel.text stringByAppendingString:digit];
                self.userIsInTheMiddleOfEnteringANumber = YES;
            }
        }
        // This is the beginning of a new number, so we'll want to append a 0
        else {
            self.displayLabel.text = [NSString stringWithFormat:@"0%@", digit];
            self.userIsInTheMiddleOfEnteringANumber = YES;
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
    if ([sender.currentTitle isEqualToString:@"C"]) {
        self.enteredLabel.text = @"";
        self.brain = nil;
        self.infixLabel.text = @"";
        self.displayLabel.text = @"0";
    }
    else {
        if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
        [self.brain performOperation:sender.currentTitle];
        self.infixLabel.text = [[self.brain class] descriptionOfProgram:self.brain.program];
        double result = [[self.brain class] runProgram:[self.brain program] usingVariableValues:self.testVariableValues];
        self.displayLabel.text = [NSString stringWithFormat:@"%g", result];
        self.enteredLabel.text = [self.enteredLabel.text stringByAppendingFormat:@"%@ ", sender.currentTitle];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Graphing"]) {
        [segue.destinationViewController setTitle:[CalculatorBrain descriptionOfProgram:self.brain.program]];
    }
}

- (IBAction)enterPressed {
    if ([self.displayLabel.text isEqualToString:@"x"] || [self.displayLabel.text isEqualToString:@"π"]) {
        [self.brain pushOperand:self.displayLabel.text];
    }
    else {
        // If is not a float value
        if ([self.displayLabel.text rangeOfString:@"."].location == NSNotFound) {
            [self.brain pushOperand:[NSNumber numberWithInt:[self.displayLabel.text intValue]]];
        } else {
            [self.brain pushOperand:[NSNumber numberWithDouble:[self.displayLabel.text doubleValue]]];
        }
    }
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.enteredLabel.text = [self.enteredLabel.text stringByAppendingFormat:@"%@ ", self.displayLabel.text];
    self.infixLabel.text = [[self.brain class] descriptionOfProgram:self.brain.program];
}

- (NSString *) popStringStack:(NSString *)stack {
    NSMutableArray *tokens = [[stack componentsSeparatedByString:@" "] mutableCopy];
    [tokens removeObject:@""];
    [tokens removeLastObject];
    return [tokens componentsJoinedByString:@" "];
}

- (IBAction)undoPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        NSString *newNum = [self.displayLabel.text substringToIndex:[self.displayLabel.text length]-1];
        self.displayLabel.text = newNum;
        self.enteredLabel.text = newNum;
        if(self.displayLabel.text.length <= 0) {
            self.userIsInTheMiddleOfEnteringANumber = false;
        }
    }
    else {
        [self.brain undoAction];
        self.infixLabel.text = [[self.brain class] descriptionOfProgram:self.brain.program];
        double result = [[self.brain class] runProgram:[self.brain program] usingVariableValues:self.testVariableValues];
        self.displayLabel.text = [NSString stringWithFormat:@"%g", result];
        self.enteredLabel.text = [self popStringStack:self.enteredLabel.text];
    }
}

- (void)viewDidUnload {
    [self setEnteredLabel:nil];
    [super viewDidUnload];
}
@end
