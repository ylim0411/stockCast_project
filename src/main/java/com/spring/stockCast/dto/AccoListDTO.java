package com.spring.stockCast.dto;

import lombok.Data;

import java.util.Date;

@Data
public class AccoListDTO {
    private Date orderDate; // 발주일
    private String productName; // 품목명
    private int purchaseQty; // 수량
    private int purchasePrice; // 단가

}
