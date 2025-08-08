package com.spring.stockCast.dto;

import lombok.Data;

@Data
public class TrafficDTO {
    private String temperature;  // 유동인구 %
    private String recommendation;
    private String icon;
}
