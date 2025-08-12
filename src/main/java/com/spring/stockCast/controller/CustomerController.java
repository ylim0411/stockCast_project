package com.spring.stockCast.controller;

import com.spring.stockCast.service.CustomerService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;


@Controller
@RequiredArgsConstructor
public class CustomerController {
    private final CustomerService customerService;

    @GetMapping("/customer")
    public String customer(Model model, HttpSession session) {

        model.addAttribute("customer", customerService.findCustomer(session));
        return "customer";
    }


}
