package com.spring.stockCast.controller;

import com.spring.stockCast.dto.CustomerDTO;
import com.spring.stockCast.service.CustomerService;
import com.spring.stockCast.service.SaleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/sale")
public class SaleController {
    private final SaleService service;
    private final CustomerService customerService;
    // 판매실적 화면 이동
    @GetMapping("/")
    public String chartForm(Model model){
        List<CustomerDTO> customers = findCustomer(model);
        System.out.println(customers.toString());
        return "sale";
    }

    // 고객정보 가져오기
    public List<CustomerDTO> findCustomer(Model model){
        model.addAttribute("customerAge",customerService.findCustomer()); // 고객 성별, 연령대 Map으로 반환
        return customerService.findAll();
    }
}
