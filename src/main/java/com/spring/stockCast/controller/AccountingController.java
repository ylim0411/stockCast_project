package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AccountingDTO;
import com.spring.stockCast.dto.SaleListDTO;
import com.spring.stockCast.service.AccountingService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/accounting")
public class AccountingController {

}