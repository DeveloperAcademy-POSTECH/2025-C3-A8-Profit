//
//  DateFormatters.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import Foundation


/// 공통 한국형 날짜 포맷터
let koreaDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.locale = Locale(identifier: "ko_KR_POSIX")
    df.dateFormat = "yyyy년 M월 d일"
    return df
}()

