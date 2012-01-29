//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Joe Smith on 11/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>

@interface CalculatorBrain : NSObject
- (void) pushOperand : (double)operand;
- (double) performOperation : (NSString *)operation;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;

@end
