//
//  DateFormatters.swift
//  Soonsu
//
//  Created by coulson on 6/3/25.
//

import Foundation


/// 공통 한국형 날짜 포맷터
/// yyyy년 M월 d일  (예: 2025년 6월 10일)
let koreaDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.locale = Locale(identifier: "ko_KR_POSIX")
    df.dateFormat = "yyyy년 M월 d일"
    return df
}()

// MARK: - 확장: 재사용 가능한 정적 포맷터
extension DateFormatter {

    /// M월 d일  (예: 6월 10일)
    static let korMonthDay: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "M월 d일"
        return df
    }()
}
