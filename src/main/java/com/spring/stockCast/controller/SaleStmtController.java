package com.spring.stockCast.controller;

import com.spring.stockCast.dto.*;
import com.spring.stockCast.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
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
    // 발주 목록 조회 (검색 + 페이징)
    @GetMapping("/saleStmtList")
    public String find(@RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate startDate,
                       @RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate endDate,
                       @RequestParam(required = false) String orderNumber,
                       @RequestParam(value = "page", defaultValue = "1") int page,
                       Model model){
        // 서비스 제일아래에 모든내용 있음
        model.addAllAttributes(saleStmtService.controller(startDate,endDate,orderNumber,page));

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
