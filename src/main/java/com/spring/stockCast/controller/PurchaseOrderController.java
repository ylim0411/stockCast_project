package com.spring.stockCast.controller;


import com.spring.stockCast.service.PurchaseOrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/purchasOrder")
public class PurchaseOrderController {
    private final PurchaseOrderService purchaseOrderService;

}
