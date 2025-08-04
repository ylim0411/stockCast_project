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
import java.util.Date;
import java.util.List;
import java.util.Map;

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
        model.addAttribute("saleList",saleService.findAll()); // 판매 건수에대한 전체 정보
        model.addAttribute("saleCategory",saleService.findCategory(saleService.findAll())); // 판매된 카테고리 및 가격
        model.addAttribute("customerAge",customerService.findCustomer()); // 고객 성별, 연령대 Map으로 반환
        return "sale";
    }

    // 날짜와 발주번호로 목록 조회하기
    @PostMapping("/findDate")
    public String find(@RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate startDate,
                       @RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate endDate,
                       @RequestParam(required = false) String year,
                       Model model){
        List<SaleDTO> sales;
        // 날짜 필터가 있을 때만 검색
        if (startDate != null && endDate != null) {
            sales = saleService.findByDate(startDate, endDate); // 기간 판매내역 불러오기
            model.addAttribute("saleList", sales); // 판매 건수에대한 전체 정보
            model.addAttribute("saleCategory",saleService.findCategory(sales)); // 판매된 카테고리 및 가격
            return "sale";
        } else {
            sales = saleService.findAll(); // 판매 건수에 대한 전체 정보
        }
        // 연도 선택시에만 검색
        if(year != null && !year.isEmpty()){
            sales = saleService.findByYear(year); // 해당 년도에 해당하는 판매내역 불러오기
        }else {
            LocalDate today = LocalDate.now(); // 오늘날짜 불러오기
            String currentYear = String.valueOf(today.getYear()); // 오늘날짜의 연도 추출
            sales = saleService.findByYear(currentYear); // 올해 거래내역 불러오기
        }
        Map<String,Integer> monthPrice = saleService.saleMonth(sales);
//        if(monthPrice == null){
//            model.addAttribute("msg","선택하신 년도의 판매정보가 존재하지 않습니다.");
//            chartForm(model);
//        }
        model.addAttribute("saleList", sales); // 판매 건수에대한 전체 정보
        model.addAttribute("saleCategory",saleService.findCategory(sales)); // 판매된 카테고리 및 가격
        model.addAttribute("monthPrice",monthPrice);
        return "sale";
    }
}
