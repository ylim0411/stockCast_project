package com.spring.stockCast.controller;


import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.service.ClientService;
import com.spring.stockCast.service.OrderStmtService;
import com.spring.stockCast.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/order")
@RequiredArgsConstructor
public class OrderStmtController {
    public final OrderStmtService orderStmtService;
    public final ClientService clientService;
    public final ProductService productService;

    @GetMapping("/orderStmt")
    public String orderStmt(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate,
            @RequestParam(required = false) String orderStmtId,
            Model model) {

        List<OrderStmtDTO> orders;

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
    public String orderSave(Model model) {
        // 거래처만 조회
        List<Map<String, Object>> clients = clientService.getAllClients();
        model.addAttribute("clients", clients);

        // 전체 상품 조회
        List<Map<String, Object>> products = productService.getProductsByCategoryId(3);
        model.addAttribute("products", products);

        return "orderSave";
    }

    @GetMapping("/orderDetail")
    public String orderDetail(){
        return "orderDetail";
    }

    @GetMapping("/new-info")
    @ResponseBody
    public Map<String, Object> getNewOrderInfo() {
        Map<String, Object> result = new HashMap<>();
        // 예시 - 실제로는 DB나 서비스에서 생성
        result.put("orderNumber", "ORD-20250803-001");
        result.put("orderDate", new Date());
        return result;
    }
}


