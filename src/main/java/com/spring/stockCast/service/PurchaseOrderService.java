package com.spring.stockCast.service;



import org.springframework.stereotype.Repository;
import com.spring.stockCast.dto.PurchaseOrderDTO;
import com.spring.stockCast.repository.PurchaseOrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PurchaseOrderService {

    private final PurchaseOrderRepository purchaseOrderRepository;


    // 발주 상세 저장
    public void saveOrderDetail(int orderId, int productId, int purchasePrice, int purchaseQty) {
        purchaseOrderRepository.insertOrderDetail(orderId, productId, purchasePrice, purchaseQty);
    }
    // 상태 완료 변경시 발주로 인한 재고, 회계 연동
    public void linkAccounting(Map<String,Object> param){
        purchaseOrderRepository.linkAccounting(param);
    }
    // 발주 상세 목록 조회
    public List<PurchaseOrderDTO> findByOrderId(int orderId) {
        return purchaseOrderRepository.findByOrderId(orderId);
    }

    public void deleteByOrderId(int orderId) {
        purchaseOrderRepository.deleteByOrderId(orderId);
    }
}

