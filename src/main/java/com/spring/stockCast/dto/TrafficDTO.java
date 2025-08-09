package com.spring.stockCast.dto;

import lombok.Data;

@Data
public class TrafficDTO {
    private String temperature;  // 전체 유동인구 %
    private String maxGroupPercentage;  // 최다 연령대 유동인구 비율 (%)
    private String maxGroup;            // 최다 유동인구 연령대
    private String recommendation;      // 추천 문구
    private String icon;

}
