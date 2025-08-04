package com.spring.stockCast.service;


import com.spring.stockCast.dto.SaleDTO;
import com.spring.stockCast.repository.SaleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SaleService {
    private final SaleRepository saleRepository;

    // 전체 판매내역 불러오기
    public List<SaleDTO> findAll() {
        return saleRepository.findAll();
    }

    // 전체 판매내역의 카테고리 리스트 가져오기(도넛차트 구성용)
    public Map<String, Integer> findCategory() {
        Map<String, Integer> categorySales = new HashMap<>();
        for (SaleDTO sale : findAll()) {
            String categoryName = sale.getCategoryName();
            int saleQty = sale.getSaleQty();

            categorySales.put(categoryName, categorySales.getOrDefault(categoryName, 0) + saleQty);
        }
        return categorySales;
    }
}
