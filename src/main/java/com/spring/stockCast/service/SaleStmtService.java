package com.spring.stockCast.service;


import com.spring.stockCast.dto.AccoListDTO;
import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.dto.SaleListDTO;
import com.spring.stockCast.dto.SaleStmtDTO;
import com.spring.stockCast.repository.SaleStmtRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SaleStmtService {
    private final SaleStmtRepository saleStmtRepository;
    private final int pageLimit = 10;   // 한 페이지 당 표시할 데이터 수
    private final int blockLimit = 5;  // 페이지 번호 블록 수

    // 거래명세서 리스트 뽑아오기
    public List<SaleListDTO> findAll() {
        return saleStmtRepository.findAll();
    }
    // 발주번호에 일치하는 리스트 출력
    public List<SaleListDTO> findByNo(String orderNumber) {
        return saleStmtRepository.findByNo(orderNumber);
    }
    // 기간에 있는 리스트 출력
    public List<SaleListDTO> findByDate(LocalDate startDate, LocalDate endDate) {
        return saleStmtRepository.findByDate(startDate,endDate);
    }
    // 거래명세서 상세보기
    public List<AccoListDTO> findBySaleId(int id) {
        return saleStmtRepository.findBySaleId(id);
    }
    // 전체 수(페이징)
    public int countAll() {
        return saleStmtRepository.saleCount();
    }
    // 발주번호 검색 + 페이징
    public List<SaleListDTO> findByNoPaging(String orderNumber, int page) {
        int pagingStart = (page - 1) * pageLimit;

        Map<String, Object> param = new HashMap<>();
        param.put("orderNumber", orderNumber);
        param.put("start", pagingStart);
        param.put("limit", pageLimit);

        List<SaleListDTO> list = saleStmtRepository.findByNoPaging(param);
        return list;
    }
    // 날짜 검색 수
    public int countByDate(LocalDate startDate, LocalDate endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        return saleStmtRepository.countByDate(param);
    }
    // 날짜 검색 + 페이징
    public List<SaleListDTO> findByDatePaging(LocalDate startDate, LocalDate endDate, int page) {
        int pagingStart = (page - 1) * pageLimit;

        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        param.put("start", pagingStart);
        param.put("limit", pageLimit);

        List<SaleListDTO> list = saleStmtRepository.findByDatePaging(param);
        return list;
    }

    public int countByNo(String orderNumber) {
        return saleStmtRepository.countByNo(orderNumber);
    }
}
