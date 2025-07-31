package com.spring.stockCast.controller;

import com.spring.stockCast.service.AccountingService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/accounting")
public class AccountingController {
    private final AccountingService accountingService;
    @GetMapping("/")
    public String listForm(){
        return "accounting";
    }
}
