package com.spring.stockCast.controller;

import com.spring.stockCast.service.SaleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/sale")
public class SaleController {
    private final SaleService service;

    @GetMapping("/")
    public String chartForm(){
        return "sale";
    }
}
