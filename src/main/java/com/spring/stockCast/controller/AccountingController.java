package com.spring.stockCast.controller;

import com.spring.stockCast.service.AccountingService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;

@Controller
@RequiredArgsConstructor
@RequestMapping("/accounting")
public class AccountingController {
    private final AccountingService accountingService;

    // 회계관리 페이지 이동
    @GetMapping("/accountingList")
    public String accountingList(@RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate startDate,
                                 @RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate endDate,
                                 @RequestParam(required = false) String year,
                                 Model model){
        // 서비스 제일아래에 모든내용 있음
        model.addAllAttributes(accountingService.controller(startDate,endDate,year));
        return "accounting";
    }
}