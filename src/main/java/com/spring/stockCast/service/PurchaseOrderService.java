package com.spring.stockCast.service;

import com.spring.stockCast.repository.PurchaseOrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PurchaseOrderService {

    private final PurchaseOrderRepository purchaseOrderRepository;

    // 발주 상세 저장
    public void saveOrderDetail(int orderId, int productId, int purchasePrice, int purchaseQty) {
        purchaseOrderRepository.insertOrderDetail(orderId, productId, purchasePrice, purchaseQty);
    }
}