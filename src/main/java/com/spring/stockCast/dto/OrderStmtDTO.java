package com.spring.stockCast.dto;

import lombok.Data;

import java.util.Date;
@Data
public class OrderStmtDTO {
    private int orderStmtId;
    private int orderId;
    private Date orderDate;
    private int purchasePrice;
    private int purchaseQty;
}

