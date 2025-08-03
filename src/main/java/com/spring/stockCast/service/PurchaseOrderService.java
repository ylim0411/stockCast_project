package com.spring.stockCast.service;

import com.spring.stockCast.dto.AccoListDTO;
import com.spring.stockCast.repository.PurchaseOrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class PurchaseOrderService {
    private final PurchaseOrderRepository purchaseOrderRepository;

    public List<AccoListDTO> findById(int id) {
        return purchaseOrderRepository.findById(id);
    }
}
