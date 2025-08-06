package com.spring.stockCast.dto;

import lombok.Data;

import java.util.Date;

@Data
public class AccoListDTO {
    private Date transactionDate; // 거래발생일
    private int itemId; // 계정과목 id
    private int value; // 발생한 가격
}
