package com.spring.stockCast.dto;

import lombok.Data;

import java.util.Date;
@Data
public class SaleStmtDTO {
    private int saleStmtId;
    private int clientId;
    private Date saleDate;
    private int transactionPrice;
    private int transactionQty;
}
