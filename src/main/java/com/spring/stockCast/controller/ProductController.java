package com.spring.stockCast.controller;

import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.service.ProductCategoryService;
import com.spring.stockCast.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/product")
public class ProductController {
    private final ProductService productService;
    private final ProductCategoryService productCategoryService;

    @GetMapping("/byClient")
    @ResponseBody
    public List<Map<String, Object>> getProductsByClient(@RequestParam int clientId) {
        return productService.getProductsByClientId(clientId);
    }

    @GetMapping("/")
    public String productList(Model model) {
        List<ProductCategoryDTO> categoryList = productCategoryService.categorySelect();
        model.addAttribute("categoryList", categoryList);

        return "product";
    }

    @GetMapping("/delete")
    public String productDelete(@RequestParam("id") int productId) {
        System.out.println("delete?" + productId);
        productService.delete(productId);
        return "redirect:/product/";
    }

}
