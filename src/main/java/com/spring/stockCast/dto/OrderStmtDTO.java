package com.spring.stockCast.dto;

import com.spring.stockCast.enums.OrderStatus;
import lombok.Data;

import java.util.Date;
@Data
public class OrderStmtDTO {
    private int orderId;
    private Date orderDate;
    private String clientName;
    private int  totalCount;
    private int totalPrice;
    private OrderStatus status;
}

