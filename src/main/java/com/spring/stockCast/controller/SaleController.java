package com.spring.stockCast.controller;

import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/sales")
public class SaleController {
    private final SaleService saleService;

    // 날짜와 선택년도로 목록 조회하기
    @GetMapping("/saleList")
    public String find(@RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate startDate,
                       @RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate endDate,
                       @RequestParam(required = false) String year,
                       Model model){
        // 서비스 제일아래에 모든내용 있음
        model.addAllAttributes(saleService.saleController(startDate,endDate,year));
        return "sale";
    }

    // 판매화면 구현
    @GetMapping("/saleOrder")
    public String saleOrder(Model model, HttpSession session){
        model.addAllAttributes(saleService.saleOrderController(session));
        return "saleOrder";
    }
    // 재고 적을시 수량 반환
    @PostMapping("/getStock")
    @ResponseBody
    public int getStock(@RequestParam String productName, HttpSession session){
        String storeId = session.getAttribute("selectedStoredId").toString();
        // 재고량을 가져오는 서비스 메서드 호출
        return saleService.findProductStock(storeId, productName);
    }
    // 판매주문시 저장
    @PostMapping("/saleOrder")
    public String saleOrder(
            @RequestParam(required = false) @DateTimeFormat(pattern =  "yyyy-MM-dd") LocalDate today,
            @RequestParam(required = false) String saleId,
            @RequestParam(value = "productName[]", required = false) List<String> productName,
            @RequestParam(value = "purchaseQty[]", required = false) List<Integer> purchaseQty,
            @RequestParam(required = false) String gender,
            @RequestParam(required = false) String age,
            HttpSession session
    ) {
        if (productName != null && !productName.isEmpty() && purchaseQty != null && !purchaseQty.isEmpty()) {
            // 주문번호에 의한 목록 등록 (이 코드가 루프 밖에 있어야 함)
            String storeId = session.getAttribute("selectedStoredId").toString(); // StoreController 에서 저장한 id 받아오기
            saleService.saleCreateStmt(saleId,storeId, today);
            // 상품과 수량 리스트를 한 번의 루프로 처리
            for (int i = 0; i < productName.size(); i++) {
                // NullPointerException 방지를 위해 인덱스 유효성 검사 추가
                if (i < purchaseQty.size()) {
                    String pName = productName.get(i);
                    Integer qty = purchaseQty.get(i);

                    // 수량이 null이 아니고 0보다 클 때만 DB에 저장
                    if (qty != null && qty > 0) {
                        int productId = saleService.findProductId(pName, storeId);

                        // DB 저장 및 회계 처리 로직 통합
                        saleService.saleSave(saleId, today, productId, qty);
                        saleService.linkAccounting(saleId, today, productId, qty);
                        saleService.insertCustomer(gender,age,storeId);
                    }
                }
            }
        }
        return "redirect:/accounting/accountingList/";

    }

    // 판매가격 찾아서 반환
    @PostMapping("/salePrice")
    @ResponseBody
    public String salePrice(@RequestParam String productName, HttpSession session){
        String storeId = session.getAttribute("selectedStoredId").toString(); // StoreController 에서 저장한 id 받아오기
        List<ProductDTO> products = saleService.findProductSaleAll(storeId); // 점포 id를 통해 점포 상품들 불러오기

        Map<String,Object> result = new HashMap<>();
        for(ProductDTO dto : products){
            result.put(dto.getProductName(),dto.getPrice());
        }
        return result.get(productName).toString();
    }
}
