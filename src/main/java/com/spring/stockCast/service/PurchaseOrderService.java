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
    public void saveOrderDetail(int storeId, int orderId, int productId, int purchasePrice, int purchaseQty) {
        Map<String, Object> param = new HashMap<>();
        param.put("storeId", storeId);
        param.put("orderId", orderId);
        param.put("productId", productId);
        param.put("purchasePrice", purchasePrice);
        param.put("purchaseQty", purchaseQty);
        purchaseOrderRepository.insertOrderDetail(param);
    }

    // 상태 완료 연동(회계+재고)
    public void linkAccounting(int storeId, int orderId, int productId, int purchasePrice, int purchaseQty){
        Map<String, Object> param = new HashMap<>();
        param.put("storeId", storeId);
        param.put("orderId", orderId);
        param.put("productId", productId);
        param.put("purchasePrice", purchasePrice);
        param.put("purchaseQty", purchaseQty);
        purchaseOrderRepository.linkAccounting(param);
    }

    // 발주 상세 목록 조회
    public List<PurchaseOrderDTO> findByOrderId(int storeId, int orderId) {
        Map<String, Object> param = new HashMap<>();
        param.put("storeId", storeId);
        param.put("orderId", orderId);
        return purchaseOrderRepository.findByOrderId(param);
    }

    // 발주 상세 전체 삭제
    public void deleteByOrderId(int storeId, int orderId) {
        Map<String, Object> param = new HashMap<>();
        param.put("storeId", storeId);
        param.put("orderId", orderId);
        purchaseOrderRepository.deleteByOrderId(param);
    }
}

