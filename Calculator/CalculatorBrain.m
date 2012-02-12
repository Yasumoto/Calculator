//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Joe Smith on 11/25/11.
//  Copyright (c) 2012 bjoli.com. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (nonatomic, strong) NSMutableArray *programStack;
+ (BOOL)isOperation:(NSString *)operation;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if(_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (BOOL)isOperation:(NSString *)operation {
    NSArray *operationsSet = [[NSArray alloc] initWithObjects:@"+", @"-", @"/", @"*", @"sin", @"cos", @"sqrt", @"π", @"C", nil];
    return [operationsSet containsObject:operation];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}

- (void)pushOperand:(id)operand
{
    if ([operand isKindOfClass:[NSNumber class]]) {
        NSNumber *number = operand;
        [self.programStack addObject:number];            
    } else if ([operand isKindOfClass:[NSString class]]) {
        NSString *operation = operand;
        [self.programStack addObject:operation];            
    }
}

- (void)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        }
        else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        }
        else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack]
                / divisor;
        }
        else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        }
        else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        }
        else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        }
        else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        }
        else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
        else if ([operation isEqualToString:@"C"]) {
            NSLog(@"Clearing the stack");
        }
    }    
    return result;
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet *variablesInProgram = [[NSMutableSet alloc] init];
    // your shit (aka stack) isn't getting cleared. hitting C doesn't blow away the program stack.
    if ([program isKindOfClass:[NSArray class]]) {
        NSArray *stack = [program copy];
        for (id item in stack) {
            if ([item isKindOfClass:[NSString class]]) {
                if (![self isOperation:item]) {
                    [variablesInProgram addObject:item];
                }
            }
        }
    }
    if ([variablesInProgram count] == 0) {
        return nil;
    }
    return [variablesInProgram copy];
}

+ (double) runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    double result = 0;
    if ([program isKindOfClass:[NSArray class]]) {
        NSMutableArray *programStack = [(NSArray *)program mutableCopy];
        for (int i = 0; i < [programStack count]; i++) {
            NSString *value = @"";
            if ([[programStack objectAtIndex:i] isEqual:@"x"]) {
                value = [variableValues objectForKey:@"x"];
                if (!value) {
                    value = @"0";
                }
                [programStack replaceObjectAtIndex:i withObject:value];
            }
            if ([[programStack objectAtIndex:i] isEqual:@"a"]) {
                value = [variableValues objectForKey:@"a"];
                if (!value) {
                    value = @"0";
                }
                [programStack replaceObjectAtIndex:i withObject:value];
            }
            if ([[programStack objectAtIndex:i] isEqual:@"b"]) {
                value = [variableValues objectForKey:@"b"];
                if (!value) {
                    value = @"0";
                }
                [programStack replaceObjectAtIndex:i withObject:value];
            }
        }
        result = [self runProgram:programStack];
    }
    return result;
}
@end
