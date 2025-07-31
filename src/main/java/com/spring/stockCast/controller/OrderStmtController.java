package com.spring.stockCast.controller;


import com.spring.stockCast.service.OrderStmtService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/order")
@RequiredArgsConstructor
public class OrderStmtController {
    private  final OrderStmtService orderStmtService;

    @GetMapping("/orderStmt")
    public String orderStmt(){
        return "orderStmt";
    }

}
