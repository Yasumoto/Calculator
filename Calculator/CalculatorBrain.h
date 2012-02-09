//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Joe Smith on 11/25/11.
//  Copyright (c) 2012 bjoli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>

@interface CalculatorBrain : NSObject
- (void) pushOperand : idoperand;
- (void) performOperation : (NSString *)operation;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program 
 usingVariableValues:(NSDictionary *)variableValues;

@end
