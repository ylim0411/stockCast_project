package com.spring.stockCast.service;



import com.spring.stockCast.dto.PurchaseOrderDTO;
import com.spring.stockCast.repository.PurchaseOrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PurchaseOrderService {

    private final PurchaseOrderRepository purchaseOrderRepository;


    // 발주 상세 저장
    public void saveOrderDetail(int orderId, int productId, int purchasePrice, int purchaseQty, Integer qty) {
        purchaseOrderRepository.insertOrderDetail(orderId, productId, purchasePrice, purchaseQty);
    }
    // 상태 완료 변경시 발주로 인한 재고, 회계 연동
    public void linkAccounting(int orderId, int productId, int purchasePrice, int purchaseQty, int qty){
        Map<String, Object> param = new HashMap<>();
        param.put("orderId", orderId);
        param.put("productId", productId);
        param.put("purchasePrice", purchasePrice);
        param.put("purchaseQty", purchaseQty);
        purchaseOrderRepository.linkAccounting(param);
    }
    // 발주 상세 목록 조회
    public List<PurchaseOrderDTO> findByOrderId(int orderId, int id) {
        return purchaseOrderRepository.findByOrderId(orderId);
    }

    public void deleteByOrderId(int orderId, int id) {
        purchaseOrderRepository.deleteByOrderId(orderId);
    }
}

