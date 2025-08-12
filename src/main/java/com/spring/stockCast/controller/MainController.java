package com.spring.stockCast.controller;

import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.dto.PurchaseOrderDTO;
import com.spring.stockCast.dto.SaleDTO;
import com.spring.stockCast.service.OrderStmtService;
import com.spring.stockCast.service.PurchaseOrderService;
import com.spring.stockCast.service.SaleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class MainController {
    private final SaleService saleService;
    private final OrderStmtService orderStmtService;
    @GetMapping("/")
    public String home() {
        return "index";
    }

    @GetMapping("/main")
    public String mainPage(Model model, HttpSession session) {
        String storeId = session.getAttribute("selectedStoredId").toString(); // StoreController 에서 저장한 id 받아오기
        List<String> topSales = saleService.findTop5(storeId);
        LocalDate today = LocalDate.now(); // 오늘날짜 불러오기
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM");
        String currentMonth = today.format(formatter); // 오늘날짜의 월 추출 String
        List<SaleDTO> sales = saleService.findByMonth(currentMonth,storeId); // 올해 거래내역 불러오기
        List<OrderStmtDTO> orders = orderStmtService.findByMonth(currentMonth,storeId); // 올해 발주내역 불러오기
        model.addAttribute("saleTop",topSales);
        model.addAttribute("monthPrice", saleService.saleDay(sales)); // 판매된 일, 매출액 맵으로 전달
        model.addAttribute("monthExpenses", orderStmtService.orderMonth(orders)); // 발주된 일, 매출액 맵으로 전달
        return "main";
    }
}
