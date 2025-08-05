package com.spring.stockCast.controller;

import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.service.ProductCategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/productCategory")
public class ProductCategoryController {
    private final ProductCategoryService productCategoryService;

    @GetMapping("/select")
    public String categoryList(Model model) {
        List<ProductCategoryDTO> categoryList = productCategoryService.categorySelect();
        model.addAttribute("categoryList", categoryList);
        return "productCategory";
    }

    // 발주 대분류 (거래처별) young
    @GetMapping("/top")
    @ResponseBody
    public List<ProductCategoryDTO> getTopCategories(@RequestParam int clientId) {
        System.out.println(" 대분류 요청 clientId: " + clientId);
        List<ProductCategoryDTO> result = productCategoryService.findTopCategoriesByClient(clientId);
        System.out.println(" 대분류 결과: " + result);
        return result;
    }

    // 발주 중분류 (대분류 + 거래처별) young
    @GetMapping("/sub")
    @ResponseBody
    public List<ProductCategoryDTO> getSubCategories(@RequestParam int parentId, @RequestParam int clientId) {
        return productCategoryService.findSubCategoriesByParentIdAndClientId(parentId, clientId);
    }

}
