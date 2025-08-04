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
@RequestMapping("/saleStmt")
public class SaleStmtController {
    private final AccountingService accountingService;
    private final PurchaseOrderService purchaseOrderService;
    private final ClientService clientService;
    private final SaleStmtService saleStmtService;

    // 거래현황 페이지 이동
    @GetMapping("/list")
    public String salelistForm(Model model){
        List<SaleListDTO> saleList = saleStmtService.findAll();
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
