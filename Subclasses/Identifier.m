//
//  Identifier.m
//  FHIR
//
//  Created by Adam Sippel on 2013-01-31.
//  Copyright (c) 2013 Mohawk College. All rights reserved.
//

#import "Identifier.h"

@implementation Identifier

@synthesize system = _system; //Establishes the namespace in which set of possible id values is unique.
@synthesize idNumber = _idNumber; //The portion of the identifier typically displayed to the user and which is unique within the context of the system.

- (id)init
{
    self = [super init];
    if (self) {
        _system = [[Uri alloc] init];
        _idNumber = [[String alloc] init];
    }
    return self;
}

- (NSDictionary *)generateAndReturnDictionary
{
    FHIRResourceDictionary *identifierDictionary = [[FHIRResourceDictionary alloc] init];
    identifierDictionary.dataForResource = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      [_system generateAndReturnDictionary], @"system",
                                      [_idNumber generateAndReturnDictionary], @"id",
                                      nil];
    identifierDictionary.resourceName = @"Identifier";
    [identifierDictionary cleanUpDictionaryValues];
    return identifierDictionary.dataForResource;
}

- (void)identifierParser:(NSDictionary *)dictionary
{
    [_system setValueURI:[dictionary objectForKey:@"system"]];
    [_idNumber setValueString:[dictionary objectForKey:@"id"]];
}

@end