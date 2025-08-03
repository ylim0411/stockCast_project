package com.spring.stockCast.dto;

import com.spring.stockCast.enums.OrderStatus;
import lombok.Data;

import java.util.Date;
@Data
public class OrderStmtDTO {
    private int orderId; // 발주번호
    private Date orderDate; // 발주일자
    private String clientName; // 거래처명
    private int  totalCount; // 총수량 (DB에 없는 이름)
    private int totalPrice; // 총가격
    private OrderStatus status; // 상태
}

