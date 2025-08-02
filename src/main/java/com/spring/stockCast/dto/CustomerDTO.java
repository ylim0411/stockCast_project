package com.spring.stockCast.dto;

import com.spring.stockCast.enums.Gender;
import lombok.Data;

@Data
public class CustomerDTO {
    private int customerId;
    private int storeId;
    private String customerName;
    private Gender gender;
    private Integer age;
    private String phone;
    private int point;
}
