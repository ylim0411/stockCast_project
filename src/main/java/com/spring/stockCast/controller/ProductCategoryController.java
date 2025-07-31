package com.spring.stockCast.controller;

import com.spring.stockCast.service.ProductCategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class ProductCategoryController {
    private final ProductCategoryService productCategoryService;
}
