package com.spring.stockCast.repository;

import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class PurchaseOrderRepository {

    private final SqlSessionTemplate sql;

    // 발주 상세 저장
    public void insertOrderDetail(int orderId, int productId, int purchasePrice, int purchaseQty) {
        Map<String, Object> param = new HashMap<>();
        param.put("orderId", orderId);
        param.put("productId", productId);
        param.put("purchasePrice", purchasePrice);
        param.put("purchaseQty", purchaseQty);

        sql.insert("PurchaseOrder.insertOrderDetail", param);
    }

}
