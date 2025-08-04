package com.spring.stockCast.service;


import com.spring.stockCast.dto.SaleDTO;
import com.spring.stockCast.repository.SaleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;

@Service
@RequiredArgsConstructor
public class SaleService {
    private final SaleRepository saleRepository;

    // 전체 판매내역 불러오기
    public List<SaleDTO> findAll() {
        return saleRepository.findAll();
    }
    // 해당 년도에 해당하는 판매내역 불러오기
    public List<SaleDTO> findByYear(String year) {
        return saleRepository.findByYear(year);
    }
    // 기간 판매내역 불러오기
    public List<SaleDTO> findByDate(LocalDate startDate, LocalDate endDate) {
        return saleRepository.findByDate(startDate,endDate);
    }
    // 전체 판매내역의 카테고리 리스트 가져오기(도넛차트 구성용)
    public Map<String, Integer> findCategory(List<SaleDTO> saleList) {
        Map<String, Integer> categorySales = new HashMap<>();
        for (SaleDTO sale : saleList) {
            String categoryName = sale.getCategoryName();
            int saleQty = sale.getSaleQty();

            categorySales.put(categoryName, categorySales.getOrDefault(categoryName, 0) + saleQty);
        }
        return categorySales;
    }
    // 연도별 매출액 월별 조회(꺾은선 그래프 구성용)
    public Map<String, Integer> saleMonth(List<SaleDTO> saleList) {
        Map<String, Integer> monthPrice = new LinkedHashMap<>();
        for (int i = 1; i <= 12; i++) {
            monthPrice.put(i + "월", 0);
        }
        for (SaleDTO sale : saleList) {
            int monthNumber = sale.getSaleDate().getMonth() + 1;
            String monthKey = monthNumber + "월";
            int currentTotal = monthPrice.get(monthKey);
            int newTotal = currentTotal + (sale.getSalePrice() * sale.getSaleQty());
            monthPrice.put(monthKey, newTotal);
        }

        return monthPrice;
    }
}
