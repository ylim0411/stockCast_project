package com.spring.stockCast.controller;


import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.service.OrderStmtService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/order")
@RequiredArgsConstructor
public class OrderStmtController {
    private  final OrderStmtService orderStmtService;

    @GetMapping("/orderStmt")
    public String orderStmt(Model model){
        List<OrderStmtDTO> orders = orderStmtService.findAll();

        model.addAttribute("orderStmt",orders);
        System.out.println(orders);
        return "orderStmt";
    }

    @GetMapping("/orderForm")
    public String orderForm(){
        return "orderForm";
    }
}


