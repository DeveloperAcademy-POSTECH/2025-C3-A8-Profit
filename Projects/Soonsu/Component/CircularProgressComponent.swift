//
//  CircularProgressView.swift
//  Component
//
//  원형 진행률 표시 및 비용 분석 결과를 보여주는 팝업 컴포넌트
//  Created by Mumin on 5/31/25.
//
 
import SwiftUI
 
/**
* 메뉴의 원가율을 원형 그래프로 표시하는 팝업 뷰
*
* 기능:
* - 원형 진행률 바로 원가율 시각화 (전체 원 = 메뉴가격 100%, 색칠된 부분 = 재료원가 비율)
* - 원가율에 따른 색상 변경 (회색/파란색/빨간색)
* - 적정성 텍스트 표시
* - 완료 버튼으로 다음 화면 이동
*/
struct CircularProgressComponent: View {
    // MARK: - Properties
    let percentage: Double          // 원가율 (재료원가/메뉴가격 * 100)
    let menuName: String           // 메뉴명
    let onComplete: () -> Void     // 완료 버튼 액션
    
    // MARK: - Computed Properties
    
    /// 원가율에 따른 색상 결정
    /// - 35% 초과: 빨간색 (높음)
    /// - 35% 이하: 파란색 (적정)
    private var progressColor: Color {
        if percentage > 35 {
            return .red
        } else {
            return .blue
        }
    }
    
    /// 원가율에 따른 상태 메시지
    private var statusMessage: some View {
        Group {
            if percentage > 35 {
                // 높은 원가율: "비중이 높습니다" (높습니다만 빨간색)
                HStack(spacing: 0) {
                    Text("비중이 ")
                        .foregroundColor(.black)
                    Text("높습니다")
                        .foregroundColor(.red)
                }
            } else {
                // 적정 원가율: "적정합니다" (적정만 파란색)
                HStack(spacing: 0) {
                    Text("적정")
                        .foregroundColor(.blue)
                    Text("합니다")
                        .foregroundColor(.black)
                }
            }
        }
        .font(.system(size: 20, weight: .bold))
        .padding(.bottom, 10)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 제목
            titleSection
            
            // 원형 진행률 표시
            circularProgressSection
            
            // 상태 메시지
            statusMessage
            
            Spacer()
            
            // 하단 완료 버튼
            bottomSection
        }
        .frame(width: 319, height: 355)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
 
// MARK: - View Components
 
extension CircularProgressComponent {
    
    /// 상단 제목 섹션
    private var titleSection: some View {
        Text("\(menuName)의 원가율은")
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding(.top, 45)
            .padding(.bottom, 35)
    }
    
    /// 원형 진행률 표시 섹션
    private var circularProgressSection: some View {
        ZStack {
            // 배경 원 (전체 메뉴가격 100%를 나타냄)
            Circle()
                .stroke(Color.gray.opacity(0.15), lineWidth: 25)
                .frame(width: 120, height: 120)
            
            // 진행률 원 (재료원가 비율을 나타냄)
            Circle()
                .trim(from: 0, to: percentage / 100)
                .stroke(
                    progressColor,
                    style: StrokeStyle(lineWidth: 25, lineCap: .butt)
                )
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(-90))  // 12시 방향부터 시작
                .animation(.easeInOut(duration: 1.0), value: percentage)
            
            // 중앙 퍼센트 표시
            percentageLabel
        }
        .padding(.bottom, 20)
    }
    
    /// 중앙 퍼센트 레이블
    private var percentageLabel: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("\(Int(percentage))")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(progressColor)
            Text("%")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(progressColor)
        }
    }
    
    /// 하단 완료 버튼 섹션
    private var bottomSection: some View {
        VStack(spacing: 0) {
            // 구분선
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
            
            // 완료 버튼
            Button(action: onComplete) {
                Text("완료")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            }
        }
    }
}
 
// MARK: - Preview
 
#Preview {
    VStack(spacing: 30) {
        // 적정 원가율 예시 (32%)
        CircularProgressComponent(
            percentage: 32,
            menuName: "함박스테이크",
            onComplete: { print("적정 원가율 완료") }
        )
        
        // 높은 원가율 예시 (38%)
        CircularProgressComponent(
            percentage: 38,
            menuName: "함박스테이크",
            onComplete: { print("높은 원가율 완료") }
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
 
