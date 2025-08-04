package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AccoListDTO;
import com.spring.stockCast.dto.ClientDTO;
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
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/sale")
public class SaleController {
    private final SaleService saleService;
    private final CustomerService customerService;
    private final AccountingService accountingService;
    private final PurchaseOrderService purchaseOrderService;
    private final ClientService clientService;
    // 판매실적 화면 이동
    @GetMapping("/list")
    public String chartForm(Model model){
        model.addAttribute("customerAge",customerService.findCustomer()); // 고객 성별, 연령대 Map으로 반환
        return "sale";
    }
    // 거래현황 페이지 이동
    @GetMapping("/saleStmt")
    public String salelistForm(Model model){
        List<SaleListDTO> saleList = accountingService.findAll();
        model.addAttribute("saleList",saleList);
        return "saleStmt";
    }
    // 거래명세서 상세화면으로 이동
    @GetMapping("/detail")
    public String saleDetail(Model model, @RequestParam("o_id") int id){
        List<AccoListDTO> accoList = purchaseOrderService.findBySaleId(id); // 발주번호와 일치하는 거래명세서 불러오기
        ClientDTO client = clientService.findBySaleId(id); // 발주번호와 일치하는 거래처 불러오기
        model.addAttribute("accoList",accoList);
        model.addAttribute("client",client);
        return "saleDetail";
    }
    // 날짜와 발주번호로 목록 조회하기
    @PostMapping("/find")
    public String find(@RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate startDate,
                       @RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate endDate,
                       @RequestParam(required = false) String orderNumber,
                       Model model){
        List<SaleListDTO> sales;
        // 날짜 필터가 있을 때만 검색
        if (startDate != null && endDate != null) {
            sales = accountingService.findByDate(startDate, endDate);
        } else if (orderNumber != null && !orderNumber.isEmpty()) {
            sales = accountingService.findByNo(orderNumber);
        } else {
            sales = accountingService.findAll();
        }

        model.addAttribute("saleList", sales);
        return "accounting";
    }
}
