package com.spring.stockCast.dto;

import com.spring.stockCast.enums.Direction;
import lombok.Data;

import java.util.Date;

@Data
public class AccountItemDTO{
    private int accountingId; // 회계장부 id
    private Date transactionDate; // 발생일자
    private String name; // 계정이름
    private int value; // 계산금
    private Direction direction; // 상태값(차변, 대변)
}
