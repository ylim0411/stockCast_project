package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AccoListDTO;
import com.spring.stockCast.dto.ClientDTO;
import com.spring.stockCast.dto.SaleDTO;
import com.spring.stockCast.dto.SaleListDTO;
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
import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/sale")
public class SaleController {
    private final CustomerService customerService;
    private final SaleService saleService;
    private final AccountingService accountingService;
    private final SaleStmtService saleStmtService;
    // 판매실적 화면 이동
    @GetMapping("/list")
    public String chartForm(Model model){
        model.addAttribute("customerAge",customerService.findCustomer()); // 고객 성별, 연령대 Map으로 반환
        model.addAttribute("saleList",saleService.findAll()); // 판매 건수에대한 전체 정보
        model.addAttribute("saleCategory",saleService.findCategory()); // 판매된 카테고리 및 가격
        return "sale";
    }
    // 날짜와 발주번호로 목록 조회하기
    @PostMapping("/findDate")
    public String find(@RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate startDate,
                       @RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate endDate,
                       @RequestParam(required = false) String orderNumber,
                       Model model){
        List<SaleListDTO> sales;
        // 날짜 필터가 있을 때만 검색
        if (startDate != null && endDate != null) {
            sales = saleStmtService.findByDate(startDate, endDate);
        } else if (orderNumber != null && !orderNumber.isEmpty()) {
            sales = saleStmtService.findByNo(orderNumber);
        } else {
            sales = saleStmtService.findAll();
        }

        model.addAttribute("saleList", sales);
        return "saleStmt";
    }
}
