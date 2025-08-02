package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AccoListDTO;
import com.spring.stockCast.dto.SaleListDTO;
import com.spring.stockCast.service.AccountingService;
import com.spring.stockCast.service.CustomerService;
import com.spring.stockCast.service.OrderingService;
import com.spring.stockCast.service.SaleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/sale")
public class SaleController {
    private final SaleService saleService;
    private final CustomerService customerService;
    private final AccountingService accountingService;
    private final OrderingService orderingService;

    // 판매실적 화면 이동
    @GetMapping("/list")
    public String chartForm(Model model){
        model.addAttribute("customerAge",customerService.findCustomer()); // 고객 성별, 연령대 Map으로 반환
        return "sale";
    }
    // 회계관리 페이지 이동
    @GetMapping("/accounting")
    public String salelistForm(Model model){
        List<SaleListDTO> saleList = accountingService.findAll();
        model.addAttribute("saleList",saleList);
        return "accounting";
    }
    // 거래명세서 상세화면으로 이동
    @GetMapping("/detail")
    public String saleDetail(Model model, @RequestParam("o_id") int id){
        List<AccoListDTO> accoList = orderingService.findById(id);
        model.addAttribute("accoList",accoList);
        return "saleDetail";
    }
    // 날짜와 발주번호로 목록 조회하기
    @PostMapping("/find")
    public String find(HttpServletRequest request){
        String sDate = request.getParameter("startDate");
        String eDate = request.getParameter("endDate");
        String orderId = request.getParameter("orderNumber");
        if((sDate != null && !sDate.trim().isEmpty())&&(eDate != null && !eDate.trim().isEmpty())){

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate startDate = LocalDate.parse(sDate,formatter);
            LocalDate endDate = LocalDate.parse(eDate,formatter);

            return "accounting";
        }
        System.out.println(sDate);
        System.out.println("e"+sDate);
        return "accounting";
    }
}
