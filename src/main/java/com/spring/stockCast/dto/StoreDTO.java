package com.spring.stockCast.dto;

import lombok.Data;

@Data
public class StoreDTO {
    private int storeId;
    private int adminId;
    private String storeName;
    private String storeAddress;
}
