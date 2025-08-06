package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AccoListDTO;
import com.spring.stockCast.dto.AccountingDTO;
import com.spring.stockCast.service.AccountingService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/accounting")
public class AccountingController {
    private final AccountingService accountingService;

    // 회계관리 페이지 이동
    @GetMapping("/list")
    public String accountingList(@RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate startDate,
                                 @RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate endDate,
                                 @RequestParam(required = false) String year,
                                 Model model){
        AccountingDTO pageData = accountingService.getAccountingPageData(); // 존재하는 모든 계정 불러오기
        String findDate="";
        List<AccoListDTO> accounts;
        // 날짜 필터가 있을 때만 검색
        if (startDate != null && endDate != null) {
            accounts = accountingService.findByDate(startDate, endDate); // 기간 거래내역 불러오기
            findDate = startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))+"~"+endDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            model.addAttribute("valueData",accounts);
            model.addAttribute("findDate",findDate);
            return "sale";
        }
        // 연도 선택시에만 검색
        if(year != null && !year.isEmpty()){
            accounts = accountingService.findByYear(year); // 해당 년도에 해당하는 판매내역 불러오기
            findDate = year;
        }else {
            LocalDate today = LocalDate.now(); // 오늘날짜 불러오기
            String currentYear = String.valueOf(today.getYear()); // 오늘날짜의 연도 추출
            accounts = accountingService.findByYear(currentYear); // 올해 거래내역 불러오기
        }
        model.addAttribute("valueData",accounts);
        model.addAttribute("pageData", pageData); // AccountingDTO 모음
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);

        model.addAttribute("findDate",findDate); // 화면에 표시될 선택된 날짜
        model.addAttribute("accountYear",accountingService.findAccountYear()); // 회계내역이 있는 년도 리스트로 전달
        return "accounting";
    }

    @PostMapping("/list")
    public String findAccounting() {
        return "redirect:/accounting/list";
    }
}