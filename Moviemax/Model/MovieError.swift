//
//  MovieError.swift
//  Moviemax
//
//  Created by Aleksey Kosov on 04.04.2023.
//

import Foundation

enum MovieError: String, Error {
    case codeError = "Проиозшла ошибка при обработке запроса. Повторите позднее"
    case errorLoadingImage = "Произошла ошибка при загрузке изображения. Повторите попытку позднее"
    case errorInvalidResponse = "Произошла ошибка при загрузке данных. Попробуйте позднее."
}
