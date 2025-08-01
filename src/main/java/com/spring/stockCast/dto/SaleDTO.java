package com.spring.stockCast.dto;

import lombok.Data;

import java.util.Date;

@Data
public class SaleDTO {
    private int saleId;
    private int productId;
    private int customerId;
    private Date saleDate;
    private int salePrice;
    private int saleQty;
}
