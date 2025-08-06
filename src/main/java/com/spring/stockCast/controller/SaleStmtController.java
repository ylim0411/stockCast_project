package com.spring.stockCast.controller;

import com.spring.stockCast.dto.*;
import com.spring.stockCast.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/saleStmt")
public class SaleStmtController {
    private final ClientService clientService;
    private final SaleStmtService saleStmtService;
    private final OrderStmtService orderStmtService;
    // 발주 목록 조회 (검색 + 페이징)
    @GetMapping("/saleStmtList")
    public String find(@RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate startDate,
                       @RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate endDate,
                       @RequestParam(required = false) String orderNumber,
                       @RequestParam(value = "page", defaultValue = "1") int page,
                       Model model){
        List<SaleListDTO> sales;
        int totalCount;
        // 날짜 필터가 있을 때만 검색
        if (startDate != null && endDate != null) {
            sales = saleStmtService.findByDatePaging(startDate, endDate, page);
            totalCount = saleStmtService.countByDate(startDate, endDate);
        } else if (orderNumber != null && !orderNumber.isEmpty()) {
            // 발주번호 검색
            sales = saleStmtService.findByNoPaging(orderNumber, page);
            totalCount = saleStmtService.countByNo(orderNumber);
        } else {
            // 전체조회
            sales = saleStmtService.pagingList(page);
            totalCount = saleStmtService.countAll();
        }
        // 페이징 정보
        PageDTO pageDTO = orderStmtService.pagingParamWithSearch(page, totalCount);

        // 검색정보 유지
        model.addAttribute("saleList", sales);
        model.addAttribute("paging", pageDTO);

        return "saleStmt";
    }
    // 거래명세서 상세화면으로 이동
    @GetMapping("/detail")
    public String saleDetail(Model model, @RequestParam("o_id") int id){
        List<SaleStmtDTO> accoList = saleStmtService.findBySaleId(id); // 발주번호와 일치하는 거래명세서 불러오기
        ClientDTO client = clientService.findBySaleId(id); // 발주번호와 일치하는 거래처 불러오기
        model.addAttribute("accoList",accoList);
        model.addAttribute("client",client);
        return "saleDetail";
    }
}
