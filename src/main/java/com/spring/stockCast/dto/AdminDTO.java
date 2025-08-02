package com.spring.stockCast.dto;

import lombok.Data;

@Data
public class AdminDTO {
    private int adminId;
    private String adminName;
    private String loginId;
    private String loginPw;
    private String businessNumber;
}
