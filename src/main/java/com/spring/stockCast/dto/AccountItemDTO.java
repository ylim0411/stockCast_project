package com.spring.stockCast.dto;

import com.spring.stockCast.enums.AccountType;
import com.spring.stockCast.enums.Direction;
import lombok.Data;

import java.util.Date;

@Data
public class AccountItemDTO{
    private int itemId; // 계정과목 id
    private String name; // 계정이름
    private Direction direction; // 상태값(차변, 대변)
    private AccountType account_type; // 속성값(자산,부채,자본,수익,비용)
}
