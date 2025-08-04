package com.spring.stockCast.service;


 import com.spring.stockCast.dto.AccoListDTO;
import org.springframework.stereotype.Repository;
import com.spring.stockCast.dto.PurchaseOrderDTO;
import com.spring.stockCast.repository.PurchaseOrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PurchaseOrderService {

    private final PurchaseOrderRepository purchaseOrderRepository;
  
      public List<AccoListDTO> findById(int id) {
        return purchaseOrderRepository.findById(id);
    }

    // 발주 상세 저장
    public void saveOrderDetail(int orderId, int productId, int purchasePrice, int purchaseQty) {
        purchaseOrderRepository.insertOrderDetail(orderId, productId, purchasePrice, purchaseQty);
    }

    // 발주 상세 목록 조회
    public List<PurchaseOrderDTO> findByOrderId(int orderId) {
        return purchaseOrderRepository.findByOrderId(orderId);
    }
}

