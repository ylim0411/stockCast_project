package com.spring.stockCast.dto;

import com.spring.stockCast.enums.OrderStatus;
import lombok.Data;

import java.util.Date;

@Data
public class SaleListDTO { // DB에 없는 DTO 화면 출력시 쿼리 종합용
    private int orderId; // 주문id
    private Date orderdate; // 주문일
    private int orderSubnum; // 점포별 구분된 발주번호
    private String clientName; // 거래처명
    private String categoryName; // 상품명
    private OrderStatus status; // 발주 상태 확인용
    private int price; // 가격
}
