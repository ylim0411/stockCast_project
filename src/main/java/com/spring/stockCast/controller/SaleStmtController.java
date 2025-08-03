package com.spring.stockCast.controller;

import com.spring.stockCast.service.SaleStmtService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/saleStmt")
public class SaleStmtController {
    private final SaleStmtService saleStmtService;

}
