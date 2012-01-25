//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Joe Smith on 11/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
	
@interface CalculatorBrain ()
@property (strong, nonatomic) NSMutableArray *operandStack;
@end


@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *) operandStack {
    if(_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (double) popOperand {
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (void) pushOperand:(double)operand {
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double) performOperation:(NSString *)operation {
    double result = 0;
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    }
    if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    }
    if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    }
    if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    }
    if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    }
    if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    }
    if ([operation isEqualToString:@"sqrt"]) {
        result = sqrt([self popOperand]);
    }
    if ([operation isEqualToString:@"π"]) {
        result = M_PI;
    }
    if ([operation isEqualToString:@"C"]) {
        NSLog(@"Clearing the stack");
        self.operandStack = [[NSMutableArray alloc] init];
        result = 0;
    }
    [self pushOperand:result];
    
    return result;
}
@end
