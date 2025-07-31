package com.spring.stockCast.dto;

import lombok.Data;

import java.util.Date;

@Data
public class OrderingDTO {
    private int orderId;
    private int productId;
    private Date orderDate;
    private int purchasePrice;
    private int purchaseQty;
}
