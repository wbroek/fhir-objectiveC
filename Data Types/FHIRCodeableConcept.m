//
//  pie.m
//  FHIR
//
//  Created by Adam Sippel on 2013-01-28.
//  Copyright (c) 2013 Mohawk College. All rights reserved.
//

#import "FHIRCodeableConcept.h"
#import "FHIRExistanceChecker.h"

@implementation FHIRCodeableConcept

@synthesize codeableConceptDictionary = _codeableConceptDictionary;

@synthesize coding = _coding; //A reference to a code defined by a terminology system. Contains "coding" objects only.
@synthesize text = _text; //A human language representation of the concept as seen/selected/uttered by the user who entered the data and/or which represents the intended meaning of the user or concept
@synthesize primary = _primary; //Indicates which of the codes in the codings was chosen by a user, if one was chosen directly

- (id)init
{
    self = [super init];
    if (self) {
        _codeableConceptDictionary = [[FHIRResourceDictionary alloc] init];
        _coding = [[NSMutableArray alloc] init];
        _text = [[FHIRString alloc] init];
        _primary = [[FHIRString alloc] init];
    }
    return self;
}

- (NSDictionary *)generateAndReturnDictionary
{
    _codeableConceptDictionary.dataForResource = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [FHIRExistanceChecker generateArray:_coding], @"coding",
                                           [FHIRExistanceChecker stringChecker:_text], @"text",
                                           [FHIRExistanceChecker stringChecker:_primary], @"primary",
                                           nil];
    _codeableConceptDictionary.resourceName = @"CodeableConcept";
    [_codeableConceptDictionary cleanUpDictionaryValues];
    return _codeableConceptDictionary.dataForResource;
}

- (void)codeableConceptParser:(NSDictionary *)dictionary
{
    //coding
    NSArray *codeArray = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"coding"]];
    _coding = [[NSMutableArray alloc] init];
    for (int i = 0; i < [codeArray count]; i++)
    {
        FHIRCoding *tempCS = [[FHIRCoding alloc] init];
        [tempCS codingParser:[codeArray objectAtIndex:i]];
        [_coding addObject:tempCS];
        //NSLog(@"%@", _coding);
    }
    
    [_text setValueString:[dictionary objectForKey:@"text"]];
    [_primary setValueString:[dictionary objectForKey:@"primary"]];
}

@end
