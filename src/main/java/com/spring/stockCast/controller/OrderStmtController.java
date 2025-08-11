package com.spring.stockCast.controller;

import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.dto.PageDTO;
import com.spring.stockCast.dto.PurchaseOrderDTO;
import com.spring.stockCast.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
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
    private final ProductCategoryService productCategoryService;

    // 발주 목록 조회 (검색 + 페이징)
    @GetMapping("/orderStmt")
    public String orderStmt(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate,
            @RequestParam(required = false) String orderStmtId,
            @RequestParam(value = "page", defaultValue = "1") int page,
            HttpSession session,
            Model model) {

        // storeId 받기
        Integer storeId = (Integer) session.getAttribute("selectedStoredId");
        if(storeId == null) storeId = 1;

        List<OrderStmtDTO> orders;
        int totalCount;

        if (startDate != null && endDate != null) { // 날짜 검색
            orders = orderStmtService.findByDatePaging(storeId, startDate, endDate, page);
            totalCount = orderStmtService.countByDate(storeId, startDate, endDate);
        } else if (orderStmtId != null && !orderStmtId.isEmpty()) { // 발주번호 검색
            orders = orderStmtService.findByNoPaging(storeId, orderStmtId, page);
            totalCount = orderStmtService.countByNo(storeId, orderStmtId);
        } else { // 전체 조회
            orders = orderStmtService.pagingList(storeId,page);
            totalCount = orderStmtService.countAll(storeId);
        }

        // 페이징 정보
        PageDTO pageDTO = orderStmtService.pagingParamWithSearch(page, totalCount);

        model.addAttribute("orderNum",orderStmtService.orderNum(storeId));
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
    public String orderSave(Model model,HttpSession session) {
        // storeId 받기
        Integer storeId = (Integer) session.getAttribute("selectedStoredId");
        if(storeId == null) storeId = 1;

        // model.addAttribute("clients", clientService.getAllClients());
        model.addAttribute("clients", clientService.findByStoreId(storeId));
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
            @RequestParam("purchaseQty[]") List<Integer> purchaseQty,
            HttpSession session
    ) {
        // storeId 받기
        Integer storeId = (Integer) session.getAttribute("selectedStoredId");
        if(storeId == null) storeId = 1;

        if (clientId <= 0) {
            throw new IllegalArgumentException("거래처를 선택하세요.");
        }

        if (!clientService.existsByStoreIdAndClientId(storeId, clientId)) {
            throw new IllegalArgumentException("권한이 없거나 유효하지 않은 거래처입니다.");
        }

        orderStmtService.saveOrder(storeId, clientId, orderId, orderDate);

        for (int i = 0; i < productId.size(); i++) {
            Integer pid = productId.get(i);
            Integer qty = purchaseQty.get(i);
            Integer price = purchasePrice.get(i);

            if (pid == null || pid <= 0) continue; // 상품 없으면 건너뜀
            if (qty == null || qty <= 0) continue; // 수량 없으면 건너뜀

            purchaseOrderService.saveOrderDetail(storeId, orderId, pid, price != null ? price : 0, qty);
        }

        return "redirect:/order/orderStmt";
    }


    // 발주 상세 페이지
    @GetMapping("/orderDetail")
    public String orderDetail(@RequestParam int id,
                              @RequestParam(required = false) String status,
                              @RequestParam(required = false) String approach,
                              HttpSession session,
                              Model model) {
        // storeId 받기
        Integer storeId = (Integer) session.getAttribute("selectedStoredId");
        if(storeId == null) storeId = 1;

        // 소유 검증: 내 매장 발주서인지 확인
        OrderStmtDTO order = orderStmtService.findById(storeId, id);
        if (order == null) {
            throw new IllegalArgumentException("해당 발주서를 찾을 수 없거나 권한이 없습니다.");
        }

        if (approach != null && !approach.isEmpty() && status != null) {
            // ★ storeId 전달
            orderStmtService.updateStatus(storeId, id, status);

            if ("완료".equals(status)) {
                for (PurchaseOrderDTO dto : purchaseOrderService.findByOrderId(storeId, id)) {
                    purchaseOrderService.linkAccounting(storeId, dto.getOrderId(), dto.getProductId(), dto.getPurchasePrice(), dto.getPurchaseQty());
                }
            }

            // 변경 후 재조회
            order = orderStmtService.findById(storeId, id);
        }

        model.addAttribute("orderInfo", orderStmtService.findById(storeId, id));
        model.addAttribute("orderItems", purchaseOrderService.findByOrderId(storeId, id));
        model.addAttribute("orderStatus",status);
        return "orderDetail";
    }

    // 발주 수정 페이지
    @GetMapping("/orderUpdate")
    public String orderUpdate(@RequestParam int id, Model model,HttpSession session) {
        // storeId 받기
        Integer storeId = (Integer) session.getAttribute("selectedStoredId");
        if(storeId == null) storeId = 1;

        var orderInfo = orderStmtService.findById(storeId, id);
        model.addAttribute("orderInfo", orderInfo);
        model.addAttribute("orderItems", purchaseOrderService.findByOrderId(storeId, id));
        //model.addAttribute("clients", clientService.getAllClients());
        model.addAttribute("clients", clientService.findByStoreId(storeId));
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
            @RequestParam("purchaseQty[]") List<Integer> purchaseQty,
            HttpSession session
    ) {

        // storeId 받기
        Integer storeId = (Integer) session.getAttribute("selectedStoredId");
        if(storeId == null) storeId = 1;

        if (!clientService.existsByStoreIdAndClientId(storeId, clientId)) {
            throw new IllegalArgumentException("권한이 없거나 유효하지 않은 거래처입니다.");
        }

        // 기본 발주 수정
        orderStmtService.updateOrder(storeId, clientId, orderId, orderDate);

        // 기존 상세 삭제
        purchaseOrderService.deleteByOrderId(storeId, orderId);

        if (productId == null) {
            return "redirect:/order/orderStmt";
        }

        int loopCount = Math.min(productId.size(),
                Math.min(purchasePrice.size(), purchaseQty.size()));

        for (int i = 0; i < loopCount; i++) {
            Integer pid = productId.get(i);
            Integer price = purchasePrice.get(i);
            Integer qty = purchaseQty.get(i);

            if (pid == null || pid <= 0) continue;
            if (qty == null || qty <= 0) continue;

            purchaseOrderService.saveOrderDetail(storeId, orderId, pid,
                    price != null ? price : 0, qty);
        }

        return "redirect:/order/orderStmt";
    }

    // 발주 삭제
    @GetMapping("/orderDelete")
    public String deleteOrder(@RequestParam int id, HttpSession session, RedirectAttributes redirectAttributes) {
        Integer storeId = (Integer) session.getAttribute("selectedStoredId");
        if (storeId == null) storeId = 1;

        try {
            // 소유 검증
            if (orderStmtService.findById(storeId, id) == null) {
                throw new IllegalArgumentException("권한이 없거나 존재하지 않는 발주입니다.");
            }

            purchaseOrderService.deleteByOrderId(storeId, id);
            orderStmtService.deleteOrder(storeId, id);
            redirectAttributes.addFlashAttribute("message", "발주서가 성공적으로 삭제되었습니다.");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "삭제 중 오류가 발생했습니다.");
        }
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
