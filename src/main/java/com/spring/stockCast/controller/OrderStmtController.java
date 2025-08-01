package com.spring.stockCast.controller;


import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.service.OrderStmtService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/order")
@RequiredArgsConstructor
public class OrderStmtController {
    private  final OrderStmtService orderStmtService;

    @GetMapping("/orderStmt")
    public String orderStmt(
            @RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate endDate,
            @RequestParam(required = false) String orderStmtId,
            Model model){
        List<OrderStmtDTO> orders;

        // 날짜 필터가 있을 때만 검색
        if (startDate != null && endDate != null) {
            orders = orderStmtService.findByDate(startDate, endDate);
        } else if (orderStmtId != null && !orderStmtId.isEmpty()) {
            orders = orderStmtService.findByNo(orderStmtId);
        } else {
            orders = orderStmtService.findAll();
        }

        model.addAttribute("orderStmt", orders);
        return "orderStmt";
    }

    @GetMapping("/orderSave")
    public String orderSave(){
        return "orderSave";
    }

    @GetMapping("/orderDetail")
    public String orderDetail(){
        return "orderDetail";
    }
}


