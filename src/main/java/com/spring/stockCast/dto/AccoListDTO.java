package com.spring.stockCast.dto;

import com.spring.stockCast.enums.Direction;
import lombok.Data;

import java.util.Date;

@Data
public class AccoListDTO {
    private Date transactionDate; // 거래발생일
    private int itemId; // 계정과목 id
    private Direction direction; // 상태값(차변, 대변)
    private int value; // 발생한 가격
}
