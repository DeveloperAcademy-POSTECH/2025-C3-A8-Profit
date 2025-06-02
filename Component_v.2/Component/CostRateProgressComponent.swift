//
//  CostRateProgressComponent.swift
//  Component
//
//  원가율을 시각적으로 표시하는 바게이지 컴포넌트
//  Created by Mumin on 5/31/25.
//

import SwiftUI

// MARK: - 원가율 바게이지 컴포넌트

/// 원가율을 175×9.49px 바게이지와 텍스트로 표시하는 컴포넌트
struct CostRateProgressComponent: View {
    let costRate: Int           // 원가율 (퍼센트)
    let menuName: String        // 메뉴명
    
    /// 바게이지 실제 너비 계산 (최대 175px)
    private var progressWidth: CGFloat {
        CGFloat(min(costRate, 100)) / 100.0 * 175
    }
    
    /// 원가율에 따른 색상 (35% 초과: 빨간색, 이하: 파란색)
    private var progressColor: Color {
        costRate > 35 ? .red : .blue
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            progressBar
            costRateText
        }
    }
}

// MARK: - 구성 요소

extension CostRateProgressComponent {
    
    /// 원가율 바게이지
    private var progressBar: some View {
        ZStack(alignment: .leading) {
            // 배경 바 (전체 메뉴가격 100%)
            RoundedRectangle(cornerRadius: 4.745)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 175, height: 9.49)
            
            // 진행률 바 (재료원가 비중)
            RoundedRectangle(cornerRadius: 4.745)
                .fill(progressColor)
                .frame(width: progressWidth, height: 9.49)
                .animation(.easeInOut(duration: 0.5), value: progressWidth)
        }
    }
    
    /// 원가율 텍스트
    private var costRateText: some View {
        Text("원가율 \(costRate)%")
            .font(.caption)
            .foregroundColor(progressColor)
            .fontWeight(.medium)
            .fixedSize()
    }
}

// MARK: - 프리뷰

#Preview {
    VStack(spacing: 20) {
        CostRateProgressComponent(costRate: 25, menuName: "샐러드")      // 파란색
        CostRateProgressComponent(costRate: 30, menuName: "함박스테이크")  // 파란색
        CostRateProgressComponent(costRate: 35, menuName: "스테이크")     // 파란색
        CostRateProgressComponent(costRate: 36, menuName: "치킨버거")     // 빨간색
    }
    .padding()
} 