package com.spring.stockCast.service;


import com.spring.stockCast.dto.*;
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
    private final OrderStmtService orderStmtService;
    private final int pageLimit = 10;   // 한 페이지 당 표시할 데이터 수
    private final int blockLimit = 5;  // 페이지 번호 블록 수

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
    // 전체 목록 페이징
    public List<SaleListDTO> pagingList(int page) {
        int pagingStart = (page - 1) * pageLimit;

        Map<String, Integer> pagingParams = new HashMap<>();
        pagingParams.put("start", pagingStart);
        pagingParams.put("limit", pageLimit);

        List<SaleListDTO> list = saleStmtRepository.pagingList(pagingParams);
        return list;
    }

    // 전체 수(페이징)
    public int countAll() {
        return saleStmtRepository.saleCount();
    }

    // 날짜 검색 수
    public int countByDate(LocalDate startDate, LocalDate endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        return saleStmtRepository.countByDate(param);
    }

    // 발주번호 검색 수
    public int countByNo(String orderNumber) {
        return saleStmtRepository.countByNo(orderNumber);
    }

    // 거래명세서 상세보기
    public List<SaleStmtDTO> findBySaleId(int id) {
        return saleStmtRepository.findBySaleId(id);
    }

    // 컨트롤러
    public Map<String,Object> controller(LocalDate startDate, LocalDate endDate, String orderNumber, int page) {

        List<SaleListDTO> sales;
        int totalCount;
        // 날짜 필터가 있을 때만 검색
        if (startDate != null && endDate != null) {
            sales = findByDatePaging(startDate, endDate, page);
            totalCount = countByDate(startDate, endDate);
        } else if (orderNumber != null && !orderNumber.isEmpty()) {
            // 발주번호 검색
            sales = findByNoPaging(orderNumber, page);
            totalCount = countByNo(orderNumber);
        } else {
            // 전체조회
            sales = pagingList(page);
            totalCount = countAll();
        }
        // 페이징 정보
        PageDTO pageDTO = orderStmtService.pagingParamWithSearch(page, totalCount);
        Map<String,Object> result = new HashMap<>();
        // 검색정보 유지
        result.put("saleList", sales);
        result.put("paging", pageDTO);

        return result;
    }



}
