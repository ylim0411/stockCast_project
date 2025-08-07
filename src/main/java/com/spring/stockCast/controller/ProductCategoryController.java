package com.spring.stockCast.controller;

import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.dto.StockQuantityDTO;
import com.spring.stockCast.service.ProductCategoryService;
import com.spring.stockCast.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/productCategory")
public class ProductCategoryController {
    private final ProductCategoryService productCategoryService;
    private final ProductService productService;

    // 카테고리 목록 조회
    @GetMapping("/list")
    public String categoryList(Model model) {
        List<StockQuantityDTO> categoryList = productCategoryService.categoryList();
        List<ProductCategoryDTO> topList = productCategoryService.findTopLevelCategories();
//        List<ProductCategoryDTO> middleList = productCategoryService.findAllMiddleLevelCategories(); // 추가 필요

        model.addAttribute("categoryList", categoryList);
        model.addAttribute("topList", topList);
//        model.addAttribute("middleList", middleList); // 필요하면 만들기

        return "productCategory";
    }

    // 카테고리 추가 등록
    @PostMapping("/save")
    public String categorySave(@RequestParam("categoryLevel") int categoryLevel,
                               @RequestParam("categoryName") String categoryName,
                               @RequestParam(value = "parentId", required = false) Integer parentId,
                               @RequestParam(value = "middleParentId", required = false) Integer middleParentId,
                               RedirectAttributes redirectAttributes) {
        try {
            if (categoryLevel == 3) {
                ProductDTO productDTO = new ProductDTO();
                productDTO.setProductName(categoryName);
                productDTO.setCategoryId(parentId); // 중분류 ID
                productCategoryService.saveProduct(productDTO);
            } else {
                ProductCategoryDTO categoryDTO = new ProductCategoryDTO();
                categoryDTO.setCategoryName(categoryName);
                categoryDTO.setCategoryLevel(categoryLevel);
                if (parentId != null) {
                    categoryDTO.setParentId(Long.valueOf(parentId));
                }
                productCategoryService.saveCategory(categoryDTO);
            }
            redirectAttributes.addFlashAttribute("message", "카테고리 등록이 완료되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "카테고리 등록 중 오류가 발생했습니다.");
        }
        return "redirect:/productCategory/list";
    }

    // 대분류 목록 조회 (모달용) (추가)
    @GetMapping("/topCategories")
    @ResponseBody
    public List<ProductCategoryDTO> getTopCategories() {
        return productCategoryService.findTopLevelCategories();
    }

    // 중분류 목록 조회 (모달용) (추가)
    @GetMapping("/middleCategories")
    @ResponseBody
    public List<ProductCategoryDTO> getMiddleCategories(@RequestParam int parentId) {
        return productCategoryService.findMiddleLevelCategoriesByParentId(parentId);
    }

    @GetMapping("/childCategories")
    @ResponseBody
    public List<ProductDTO> getChildCategories(@RequestParam int parentId) {
        return productService.findProductsByCategoryId(parentId);
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
