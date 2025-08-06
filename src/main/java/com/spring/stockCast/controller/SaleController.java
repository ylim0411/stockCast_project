package com.spring.stockCast.controller;

import com.spring.stockCast.dto.SaleDTO;
import com.spring.stockCast.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/sale")
public class SaleController {
    private final CustomerService customerService;
    private final SaleService saleService;

    // 날짜와 선택년도로 목록 조회하기
    @GetMapping("/list")
    public String find(@RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate startDate,
                       @RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate endDate,
                       @RequestParam(required = false) String year,
                       Model model){
        String findDate="";
        List<SaleDTO> sales;
        // 날짜 필터가 있을 때만 검색
        if (startDate != null && endDate != null) {
            sales = saleService.findByDate(startDate, endDate); // 기간 판매내역 불러오기
            findDate = startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))+"~"+endDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            addSaleDataToModel(model,sales);
            model.addAttribute("findDate",findDate);
            return "sale";
        }
        // 연도 선택시에만 검색
        if(year != null && !year.isEmpty()){
            sales = saleService.findByYear(year); // 해당 년도에 해당하는 판매내역 불러오기
            findDate = year;
        }else {
            LocalDate today = LocalDate.now(); // 오늘날짜 불러오기
            String currentYear = String.valueOf(today.getYear()); // 오늘날짜의 연도 추출
            sales = saleService.findByYear(currentYear); // 올해 거래내역 불러오기
        }
        addSaleDataToModel(model,sales);
        model.addAttribute("findDate",findDate); // 화면에 표시될 선택된 날짜
        return "sale";
    }

    // sale로 보내기 함수
    private void addSaleDataToModel(Model model, List<SaleDTO> sales) {
        model.addAttribute("saleList", sales); // 판매 건수에대한 전체 정보
        model.addAttribute("saleCategory", saleService.findCategory(sales)); // 판매된 카테고리 및 가격
        model.addAttribute("monthPrice", saleService.saleMonth(sales)); // 판매된 월, 매출액 맵으로 전달
        model.addAttribute("customerAge", customerService.findCustomer()); // 판매된 월, 매출액 맵으로 전달
        model.addAttribute("saleYear",saleService.findSaleYear()); // 판매내역이 있는 년도 리스트로 전달
    }
}
