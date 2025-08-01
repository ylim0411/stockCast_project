package com.spring.stockCast.dto;

import lombok.Data;

import java.util.Date;
@Data
public class SaleStmtDTO {
    private int orderId;
    private Date orderdate;
    private String clientName;
    private String productName;
    private int price;
}
