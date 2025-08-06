package com.spring.stockCast.service;


import com.spring.stockCast.dto.SaleDTO;
import com.spring.stockCast.repository.SaleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
public class SaleService {
    private final SaleRepository saleRepository;

    // 전체 판매내역 불러오기
    public List<SaleDTO> findAll() {
        return saleRepository.findAll();
    }
    // 판매내역이 있는 년도 불러오기
    public List<String> findSaleYear(){
        return saleRepository.findSaleYear();
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
    // 컨트롤러
    public Map<String,Object> controller(LocalDate startDate, LocalDate endDate, String year) {
        String findDate="";
        List<SaleDTO> sales;
        // 날짜 필터가 있을 때만 검색
        if (startDate != null && endDate != null) {
            sales = findByDate(startDate, endDate); // 기간 판매내역 불러오기
            findDate = startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))+"~"+endDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }
        // 연도 선택시에만 검색
        else if(year != null && !year.isEmpty()){
            sales = findByYear(year); // 해당 년도에 해당하는 판매내역 불러오기
            findDate = year;
        }else {
            LocalDate today = LocalDate.now(); // 오늘날짜 불러오기
            String currentYear = String.valueOf(today.getYear()); // 오늘날짜의 연도 추출
            sales = findByYear(currentYear); // 올해 거래내역 불러오기
        }
        Map<String,Object> result = new HashMap<>();
        result.put("findDate",findDate); // 화면에 표시될 선택된 날짜
        result.put("saleList", sales); // 판매 건수에대한 전체 정보
        result.put("saleCategory", findCategory(sales)); // 판매된 카테고리 및 가격
        result.put("monthPrice", saleMonth(sales)); // 판매된 월, 매출액 맵으로 전달
        result.put("saleYear", findSaleYear()); // 판매내역이 있는 년도 리스트로 전달

        return result;
    }
}
