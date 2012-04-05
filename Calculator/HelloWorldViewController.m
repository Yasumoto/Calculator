//
//  HelloWorldViewController.m
//  Calculator
//
//  Created by Joe Smith on 11/25/11.
//  Copyright (c) 2012 bjoli.com. All rights reserved.
//

#import "HelloWorldViewController.h"
#import "CalculatorBrain.h"
#import <Foundation/NSException.h>

@interface HelloWorldViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
- (void) updateVariableDisplay;
@end

@implementation HelloWorldViewController
@synthesize enteredLabel = _enteredLabel;
@synthesize infixLabel = _infixLabel;

@synthesize displayLabel = _displayLabel;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;
@synthesize variablesLabel = _variablesLabel;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    self.enteredLabel.text = [self.enteredLabel.text stringByAppendingFormat:@"%@", sender.currentTitle];
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

- (void) updateVariableDisplay {
    self.variablesLabel.text = @"";
    NSSet *variablesSet = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    NSString *variableValue;
    for (id variable in variablesSet) {
        variableValue = [self.testVariableValues valueForKey:variable];
        if (!variableValue) {
            variableValue = @"0";
        }
        self.variablesLabel.text = [self.variablesLabel.text stringByAppendingFormat:@"%@ = %@  ", variable, variableValue];
        
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    [self.brain performOperation:sender.currentTitle];
    self.infixLabel.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    double result = [[self.brain class] runProgram:[self.brain program] usingVariableValues:self.testVariableValues];
    self.displayLabel.text = [NSString stringWithFormat:@"%g", result];
    if ([sender.currentTitle  isEqualToString:@"C"]) {
        self.enteredLabel.text = @"";
        self.brain = nil;
        self.infixLabel.text = @"";
    }
    else {
        self.enteredLabel.text = [self.enteredLabel.text stringByAppendingFormat:@"%@ ", sender.currentTitle];
    }
    [self updateVariableDisplay];
}


- (IBAction)enterPressed {
    if ([self.displayLabel.text isEqualToString:@"x"] || [self.displayLabel.text isEqualToString:@"a"] || [self.displayLabel.text isEqualToString:@"b"]
        || [self.displayLabel.text isEqualToString:@"π"]) {
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
    self.enteredLabel.text = [self.enteredLabel.text stringByAppendingFormat:@" "];
    [self updateVariableDisplay];
    self.infixLabel.text = [[self.brain class] descriptionOfProgram:self.brain.program];
}

- (IBAction)test1Pressed:(UIButton *)sender {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithFloat:1.0], @"x",
                               [NSNumber numberWithFloat:2.0], @"a",
                               [NSNumber numberWithFloat:3.0], @"b", nil];
    [self updateVariableDisplay];
}

- (IBAction)test2Pressed:(UIButton *)sender {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithFloat:-10.0], @"x",
                               [NSNumber numberWithFloat:9001.0], @"a", nil];
    [self updateVariableDisplay];
}

- (IBAction)testNilPressed:(UIButton *)sender {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               nil, @"x",
                               nil, @"a",
                               nil, @"b", nil];
    [self updateVariableDisplay];
}

- (NSString *) popStringStack:(NSString *)stack {
    NSRange lastItem = [stack rangeOfString:@" " options:NSBackwardsSearch];
    if (lastItem.length > 0) {
        return [stack substringToIndex:lastItem.location-1];
    }
    return @"";
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
