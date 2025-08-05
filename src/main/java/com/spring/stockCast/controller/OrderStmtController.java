package com.spring.stockCast.controller;

import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.dto.PageDTO;
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

    // 발주 목록 조회 (검색 + 페이징)
    @GetMapping("/orderStmt")
    public String orderStmt(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate,
            @RequestParam(required = false) String orderStmtId,
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model) {

        List<OrderStmtDTO> orders;
        int totalCount;

        if (startDate != null && endDate != null) { // 날짜 검색
            orders = orderStmtService.findByDatePaging(startDate, endDate, page);
            totalCount = orderStmtService.countByDate(startDate, endDate);
        } else if (orderStmtId != null && !orderStmtId.isEmpty()) { // 발주번호 검색
            orders = orderStmtService.findByNoPaging(orderStmtId, page);
            totalCount = orderStmtService.countByNo(orderStmtId);
        } else { // 전체 조회
            orders = orderStmtService.pagingList(page);
            totalCount = orderStmtService.countAll();
        }

        // 페이징 정보
        PageDTO pageDTO = orderStmtService.pagingParamWithSearch(page, totalCount);

        model.addAttribute("orderStmt", orders);
        model.addAttribute("paging", pageDTO);

        // 검색 조건 유지
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("orderStmtId", orderStmtId);

        return "orderStmt";
    }

    // 발주 작성 페이지
    @GetMapping("/orderSave")
    public String orderSave(Model model) {
        model.addAttribute("clients", clientService.getAllClients());
        return "orderSave";
    }

    // 발주 저장
    @PostMapping("/orderSave")
    public String saveOrder(
            @RequestParam int clientId,
            @RequestParam int orderId,
            @RequestParam String orderDate,
            @RequestParam("productId[]") List<Integer> productId,
            @RequestParam("purchasePrice[]") List<Integer> purchasePrice,
            @RequestParam("purchaseQty[]") List<Integer> purchaseQty
    ) {
        orderStmtService.saveOrder(clientId, orderId, orderDate);

        for (int i = 0; i < productId.size(); i++) {
            purchaseOrderService.saveOrderDetail(orderId, productId.get(i), purchasePrice.get(i), purchaseQty.get(i));
        }
        return "redirect:/order/orderStmt";
    }

    // 발주 상세 페이지
    @GetMapping("/orderDetail")
    public String orderDetail(@RequestParam int id, Model model) {
        model.addAttribute("orderInfo", orderStmtService.findById(id));
        model.addAttribute("orderItems", purchaseOrderService.findByOrderId(id));
        return "orderDetail";
    }

    // 발주 수정 페이지
    @GetMapping("/orderUpdate")
    public String orderUpdate(@RequestParam int id, Model model) {
        var orderInfo = orderStmtService.findById(id);
        model.addAttribute("orderInfo", orderInfo);
        model.addAttribute("orderItems", purchaseOrderService.findByOrderId(id));
        model.addAttribute("clients", clientService.getAllClients());
        model.addAttribute("products", productService.getProductsByClientId(orderInfo.getClientId()));
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
        orderStmtService.updateOrder(clientId, orderId, orderDate);

        purchaseOrderService.deleteByOrderId(orderId);
        for (int i = 0; i < productId.size(); i++) {
            purchaseOrderService.saveOrderDetail(orderId, productId.get(i), purchasePrice.get(i), purchaseQty.get(i));
        }
        return "redirect:/order/orderStmt";
    }

    // 발주 삭제
    @GetMapping("/orderDelete")
    public String deleteOrder(@RequestParam int id) {
        purchaseOrderService.deleteByOrderId(id);
        orderStmtService.deleteOrder(id);
        return "redirect:/order/orderStmt";
    }

    // 새로운 발주번호, 등록일 생성
    @GetMapping("/new-info")
    @ResponseBody
    public Map<String, Object> getNewOrderInfo() {
        Map<String, Object> result = new HashMap<>();
        result.put("orderNumber", orderStmtService.getLastOrderId() + 1);
        result.put("orderDate", LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        return result;
    }
}
