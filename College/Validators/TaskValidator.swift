//
//  TaskValidator.swift
//  College
//
//  Created by Moch Gufron on 5/29/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import Validator
typealias TaskValidatorResult = [String: ValidationResult]
struct TaskValidator: Validatable{
    let data: [String: Any?]
    struct Tags{
        static let Subject: String = "subject"
        static let Description: String = "description"
        static let Deadline: String = "deadline"
    }
    enum ValidatorErrors: String, ValidationErrorType{
        case SUBJECT_REQUIRED
        case DESCRIPTION_REQUIRED
        case DEADLINE_REQUIRED
        var message: String{ return self.rawValue.localize }
    }
    
    func validate() -> (Bool, TaskValidatorResult) {
        var results: TaskValidatorResult = TaskValidatorResult()
        //        rules definition
        var subjectRules = ValidationRuleSet<String>()
        subjectRules.addRule(ValidationRuleRequired<String>(failureError: ValidatorErrors.SUBJECT_REQUIRED))
        
        var descriptionRules = ValidationRuleSet<String>()
        descriptionRules.addRule(ValidationRuleRequired<String>(failureError: ValidatorErrors.DESCRIPTION_REQUIRED))
        
        
        var dateRules = ValidationRuleSet<NSDate>()
        dateRules.addRule(ValidationRuleRequired<NSDate>(failureError: ValidatorErrors.DEADLINE_REQUIRED))
        //        rules validation
        let subject = data[Tags.Subject] as? String
        results[Tags.Subject] = Validator.validate(input: subject, rules: subjectRules)
        let description = data[Tags.Description] as? String
        results[Tags.Description] = Validator.validate(input: description, rules: descriptionRules)
        let date = data[Tags.Deadline] as? NSDate
        results[Tags.Deadline] = Validator.validate(input: date, rules: dateRules)
        
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