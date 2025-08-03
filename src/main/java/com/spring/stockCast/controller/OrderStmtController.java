package com.spring.stockCast.controller;


import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.service.ClientService;
import com.spring.stockCast.service.OrderStmtService;
import com.spring.stockCast.service.PurchaseOrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/order")
@RequiredArgsConstructor
public class OrderStmtController {
    private final OrderStmtService orderStmtService;
    private final ClientService clientService;
    private final PurchaseOrderService purchaseOrderService;

    // 발주 목록 조회
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

    // 발주 작성 페이지
    @GetMapping("/orderSave")
    public String orderSave(Model model) {
        List<Map<String, Object>> clients = clientService.getAllClients();
        model.addAttribute("clients", clients);
        return "orderSave";
    }

    // 발주 저장 (orderStmt + purchaseOrder)
    @PostMapping("/orderSave")
    public String saveOrder(
            @RequestParam int clientId,
            @RequestParam int orderId,
            @RequestParam String orderDate,
            @RequestParam("productId[]") List<Integer> productId,
            @RequestParam("purchasePrice[]") List<Integer> purchasePrice,
            @RequestParam("purchaseQty[]") List<Integer> purchaseQty
    ) {
        // orderStmt 저장
        orderStmtService.saveOrder(clientId, orderId, orderDate);

        // purchaseOrder 저장
        for (int i = 0; i < productId.size(); i++) {
            System.out.println("▶ Saving orderDetail: " + productId.get(i) + ", " + purchasePrice.get(i) + ", " + purchaseQty.get(i));
            purchaseOrderService.saveOrderDetail(orderId, productId.get(i), purchasePrice.get(i), purchaseQty.get(i));
        }

        return "redirect:/order/orderStmt";
    }

    // 발주 상세 페이지
    @GetMapping("/orderDetail")
    public String orderDetail() {
        return "orderDetail";
    }

    // 새로운 발주번호, 등록일 생성
    @GetMapping("/new-info")
    @ResponseBody
    public Map<String, Object> getNewOrderInfo() {
        Map<String, Object> result = new HashMap<>();
        int nextId = orderStmtService.getLastOrderId() + 1;

        result.put("orderNumber", nextId);
        result.put("orderDate", LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        return result;
    }
}
