package com.spring.stockCast.dto;

import lombok.Data;

import java.util.Date;

@Data
public class SaleListDTO { // DB에 없는 DTO 화면 출력시 쿼리 종합용
    private int orderId;
    private Date orderdate;
    private String clientName;
    private String productName;
    private int price;
}
