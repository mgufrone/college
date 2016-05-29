//
//  ScheduleValidator.swift
//  College
//
//  Created by Moch Gufron on 5/28/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import Validator
import Eureka
typealias ScheduleValidatorResult = [String: ValidationResult]
struct ScheduleValidator: Validatable{
    
    let data: [String: Any?]
    struct Tags{
        static let Subject: String = "subject"
        static let Description: String = "description"
        static let Lecturer: String = "lecturer"
        static let Date: String = "date"
        static let Start: String = "start"
        static let End: String = "end"
        static let Room: String = "room"
    }
    enum ValidatorErrors: String, ValidationErrorType{
        case SUBJECT_REQUIRED
        case DESCRIPTION_REQUIRED
        case LECTURER_REQUIRED
        case LECTURER_INVALID
        case ROOM_REQUIRED
        case DATE_REQUIRED
        case START_REQUIRED
        case END_REQUIRED
        var message: String{ return self.rawValue.localize }
    }
    
    func validate() -> (Bool, ScheduleValidatorResult) {
        var results: ScheduleValidatorResult = ScheduleValidatorResult()
//        rules definition
        var subjectRules = ValidationRuleSet<String>()
        subjectRules.addRule(ValidationRuleRequired<String>(failureError: ValidatorErrors.SUBJECT_REQUIRED))
        
        var descriptionRules = ValidationRuleSet<String>()
        descriptionRules.addRule(ValidationRuleRequired<String>(failureError: ValidatorErrors.DESCRIPTION_REQUIRED))
        
        var lecturerRules = ValidationRuleSet<String>()
        lecturerRules.addRule(ValidationRuleRequired<String>(failureError: ValidatorErrors.LECTURER_REQUIRED))
        lecturerRules.addRule(ValidationRulePattern(pattern: "^[a-zA-Z\\s\\.\\,]+$", failureError: ValidatorErrors.LECTURER_INVALID))
        
        
        var dateRules = ValidationRuleSet<NSDate>()
        dateRules.addRule(ValidationRuleRequired<NSDate>(failureError: ValidatorErrors.DATE_REQUIRED))
        var startRules = ValidationRuleSet<NSDate>()
        startRules.addRule(ValidationRuleRequired<NSDate>(failureError: ValidatorErrors.START_REQUIRED))
        var endRules = ValidationRuleSet<NSDate>()
        endRules.addRule(ValidationRuleRequired<NSDate>(failureError: ValidatorErrors.END_REQUIRED))
        
        var roomRules = ValidationRuleSet<String>()
        roomRules.addRule(ValidationRuleRequired<String>(failureError: ValidatorErrors.ROOM_REQUIRED))
//        rules validation
        let subject = data[Tags.Subject] as? String
        results[Tags.Subject] = Validator.validate(input: subject, rules: subjectRules)
        let description = data[Tags.Description] as? String
        results[Tags.Description] = Validator.validate(input: description, rules: descriptionRules)
        let lecturer = data[Tags.Lecturer] as? String
        results[Tags.Lecturer] = Validator.validate(input: lecturer, rules: lecturerRules)
        let room = data[Tags.Room] as? String
        results[Tags.Room] = Validator.validate(input: room, rules: roomRules)
        let date = data[Tags.Date] as? NSDate
        results[Tags.Date] = Validator.validate(input: date, rules: dateRules)
        let start = data[Tags.Start] as? NSDate
        results[Tags.Start] = Validator.validate(input: start, rules: startRules)
        let end = data[Tags.Start] as? NSDate
        results[Tags.End] = Validator.validate(input: end, rules: endRules)
        
        var isValid: [Bool] = []
        for (_, result) in results.enumerate(){
            switch result.1 {
            case .Valid:
                isValid.append(true)
            case .Invalid(_):
                isValid.append(false)
            }
        }
        return (!isValid.contains(false), results)
    }
}