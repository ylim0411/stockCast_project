package com.spring.stockCast.controller;


import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.dto.PurchaseOrderDTO;
import com.spring.stockCast.service.ClientService;
import com.spring.stockCast.service.OrderStmtService;
import com.spring.stockCast.service.ProductService;
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
    private final ProductService productService;

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
    public String orderDetail(@RequestParam int id, Model model) {
        // 발주 기본 정보
        OrderStmtDTO orderInfo = orderStmtService.findById(id);

        // 발주 품목 목록
        List<PurchaseOrderDTO> orderItems = purchaseOrderService.findByOrderId(id);

        model.addAttribute("orderInfo", orderInfo);
        model.addAttribute("orderItems", orderItems);

        return "orderDetail";
    }

    // 발주 수정 페이지 이동
    @GetMapping("/orderUpdate")
    public String orderUpdate(@RequestParam int id, Model model) {
        OrderStmtDTO orderInfo = orderStmtService.findById(id);
        model.addAttribute("orderInfo", orderInfo);

        List<PurchaseOrderDTO> orderItems = purchaseOrderService.findByOrderId(id);
        model.addAttribute("orderItems", orderItems);

        List<Map<String, Object>> clients = clientService.getAllClients();
        model.addAttribute("clients", clients);

        List<Map<String, Object>> products = productService.getProductsByClientId(orderInfo.getClientId());
        model.addAttribute("products", products);

        return "orderUpdate";
    }

    // 발주 수정 저장
    @PostMapping("/orderUpdate")
    public String updateOrder(
            @RequestParam int orderId,
            @RequestParam String orderDate,
            @RequestParam int clientId,
            @RequestParam("productId[]") List<Integer> productId,
            @RequestParam("purchasePrice[]") List<Integer> purchasePrice,
            @RequestParam("purchaseQty[]") List<Integer> purchaseQty
    ) {
        // 발주 기본 정보 수정
        orderStmtService.updateOrder(clientId, orderId, orderDate);

        // 기존 발주 상세 삭제 후 재등록
        purchaseOrderService.deleteByOrderId(orderId);
        for (int i = 0; i < productId.size(); i++) {
            purchaseOrderService.saveOrderDetail(orderId, productId.get(i), purchasePrice.get(i), purchaseQty.get(i));
        }

        return "redirect:/order/orderStmt";
    }

    // 발주 삭제
    @GetMapping("/orderDelete")
    public String deleteOrder(@RequestParam int id) {
        // 1. 발주 상세(구매 상품) 먼저 삭제
        purchaseOrderService.deleteByOrderId(id);
        // 2. 발주서 삭제
        orderStmtService.deleteOrder(id);

        return "redirect:/order/orderStmt";
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
