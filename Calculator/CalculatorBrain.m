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
+ (BOOL)isVariable:(NSString *)variable;
+ (NSString *)describeStack:(NSMutableArray *)stack;
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
    if ([self isUnaryOperation:operation] || [self isBinaryOperation:operation]
        || [self isNonOperation:operation]) {
        return TRUE;
    }
    return FALSE;
}

+ (BOOL)isBinaryOperation:(NSString *)operation {
    NSArray *operationsSet = [[NSArray alloc] initWithObjects:@"+", @"-", @"/", @"*", nil];
    return [operationsSet containsObject:operation];
}

+(BOOL)isUnaryOperation:(NSString *)operation {
    NSArray *unaryOperationsSet = [[NSArray alloc] initWithObjects:@"sin", @"cos", @"sqrt", nil];
    return [unaryOperationsSet containsObject:operation];
}

+(BOOL)isNonOperation:(NSString *)operation {
    NSArray *nonOperationSet = [[NSArray alloc] initWithObjects:@"π", @"C", nil];
    return [nonOperationSet containsObject:operation];
}

+ (BOOL)isVariable:(NSString *)variable {
    NSArray *variableSet = [[NSArray alloc] initWithObjects:@"a", @"b", @"x", nil];
    return [variableSet containsObject:variable];
}

+ (NSString *)describeStack:(NSMutableArray *)stack {
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    }
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [topOfStack stringValue];
    }
    else if ([self isUnaryOperation:topOfStack]){
        return [NSString stringWithFormat:@"%@(%@)", topOfStack, [self describeStack:stack]];
    }
    else if ([self isBinaryOperation:topOfStack]) {
        NSString *previousEntry = [self describeStack:stack];
        return [NSString stringWithFormat:@"(%@ %@ %@)", [self describeStack:stack], topOfStack, previousEntry];
    }
    else {
        NSString *varOrPi = topOfStack;
        return varOrPi;
    }
    return nil;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self describeStack:stack];    
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
            if ([self isVariable:[programStack objectAtIndex:i]]) {
                value = [variableValues objectForKey:[programStack objectAtIndex:i]];
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
