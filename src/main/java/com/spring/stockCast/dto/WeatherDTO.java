package com.spring.stockCast.dto;

import lombok.Data;

@Data
public class WeatherDTO {
    private String fcstDate;    // 날짜
    private String temperature; // 기온
    private String sky;         // 하늘 상태
    private String pty;         // 강수 형태
    private String pop;         // 강수 확률

    private String recommendation;
    private String icon;
}
