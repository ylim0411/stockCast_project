package com.spring.stockCast.dto;

import lombok.Data;

@Data
public class TrafficDTO {
    private String temperature;  // 전체 유동인구 %
    private String recommendation;
    private String icon;
    private String maxGroup;

    private String age10; // 10대
    private String age20; // 20대
    private String age30; // 30대
    private String age40; // 40대
    private String age50; // 50대
    private String age60; // 60대
    private String age70; // 70대

}
