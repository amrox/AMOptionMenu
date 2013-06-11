//
//  AMOptionMenu.h
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
//
//  Copyright (c) 2009 Andy Mroczkowski
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@protocol AMOptionMenuControllerDelegate <NSObject>
- (void)didChooseOption:(NSString *)value forSection:(NSString *)section;
@end

extern NSString* const kAMOptionPopUpButtonTitle;

@interface AMOptionMenuItem : NSObject {}

@property (nonatomic, retain) NSString* identifier;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* shortTitle;
@property (nonatomic, readonly) NSString* titleForSummary;
@property (nonatomic, readonly) BOOL bindValue;

+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title bindValue:(BOOL)bindValue;
+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title shortTitle:(NSString*)shortTitle bindValue:(BOOL)bindValue;
@end


extern NSString* const kAMOptionMenuContentWillChange;
extern NSString* const kAMOptionMenuContentDidChange;


@interface AMOptionMenuController : NSObject {}

@property (nonatomic, readonly) NSString* summaryString;
@property (nonatomic, assign) BOOL shouldSeparateSections;
@property (nonatomic, assign) BOOL allowUnkownOptions;
@property (nonatomic, assign) NSUInteger maxValuesInSummary; // defaults to NSUIntegerMax;
@property (nonatomic, assign) id<AMOptionMenuControllerDelegate> delegate;

@property (nonatomic, retain) NSDictionary* valuesDict;
@property (nonatomic, retain) NSArray* options;

- (void) insertOptionWithIdentifier:(NSString*)identifier title:(NSString*)title atIndex:(NSInteger)index;
- (void) setAlternatives:(NSArray*)alternatives forOptionWithIdentifier:(NSString*)optionIdentifier;
- (void) insertOption:(AMOptionMenuItem*)option atIndex:(NSInteger)insertIndex withAternatives:(NSArray*)alternatives;

- (BOOL) insertOptionsFromPropertyListWithURL:(NSURL*)url atIndex:(NSInteger)insertIndex;

- (void) insertItemsInMenu:(NSMenu*)menu atIndex:(NSInteger)insertIndex;

// TODO: make a property?
- (NSDictionary*) state;

@end

