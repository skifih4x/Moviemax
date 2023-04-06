//
//  Dateformatter + Extension.swift
//  Movve
//
//  Created by Aleksey Kosov on 22.01.2023.
//

import Foundation

extension String {

    func convertDateString() -> String? {

      //  let inputDateString = "2022-12-07"
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"

        let inputDate = inputDateFormatter.date(from: self)

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MMM dd, yyyy"

        guard let safeInputDate = inputDate else { return nil }

        let outputDateString = outputDateFormatter.string(from: safeInputDate)

        return outputDateString

    }

    func convertToYear() -> String? {

      //  let inputDateString = "2022-12-07"
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"

        let inputDate = inputDateFormatter.date(from: self)

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy"

        guard let safeInputDate = inputDate else { return nil }

        let outputDateString = outputDateFormatter.string(from: safeInputDate)

        return outputDateString

    }// "Dec 07, 2022"

}
