package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AccountingDTO;
import com.spring.stockCast.service.AccountingService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/accounting")
public class AccountingController {
    private final AccountingService accountingService;

    @GetMapping("/")
    public String listForm(Model model){
        List<AccountingDTO> accountList = accountingService.findAll();
        model.addAttribute("accountList",accountList);
        return "accounting";
    }
}
