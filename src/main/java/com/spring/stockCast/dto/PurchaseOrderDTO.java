package com.spring.stockCast.dto;

import lombok.Data;

import java.util.Date;

@Data
public class PurchaseOrderDTO {
    private int orderStmtId;
    private int orderId;
    private int productId;
    private String productName;
    private String orderDate;
    private int purchasePrice;
    private int purchaseQty;
}
