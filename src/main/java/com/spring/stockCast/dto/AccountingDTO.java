package com.spring.stockCast.dto;

import lombok.Data;

import java.util.Date;
@Data
public class AccountingDTO {
    private int accountingId;
    private int saleId;
    private int orderId;
    private Date transactionDate;
    private int salesAmount;
    private int netProfit;
    private int cost;
    private int income;
}
