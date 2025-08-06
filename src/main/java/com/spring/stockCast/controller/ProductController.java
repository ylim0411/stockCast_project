package com.spring.stockCast.controller;

import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.dto.StockQuantityDTO;
import com.spring.stockCast.service.ProductCategoryService;
import com.spring.stockCast.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

    @GetMapping("/list")
    public String productList(Model model) {
        List<ProductCategoryDTO> categoryList = productCategoryService.categorySelect();
        model.addAttribute("categoryList", categoryList);

        return "product";
    }

    @PostMapping("/update")
    public String updateProduct(@RequestParam("productId") int productId,
                                @RequestParam("productName") String productName,
                                @RequestParam("price") int price,
                                @RequestParam("stockQuantity") int stockQuantity,
                                @RequestParam("middleCategoryId") int middleCategoryId) {

        ProductDTO product = new ProductDTO();
        product.setProductId(productId);
        product.setProductName(productName);
        product.setPrice(price);
        product.setStockQuantity(stockQuantity);
        product.setCategoryId(middleCategoryId); // ← 여기에 중분류 ID 넣는 게 핵심

        productService.updateProduct(product);
        return "redirect:/product/";
    }

    @PostMapping("/add")
    public String addProduct(@RequestParam("addProductName") String productName,
                             @RequestParam("addPrice") int price,
                             @RequestParam("addStockQuantity") int stockQuantity,
                             @RequestParam("addMiddleCategoryId") int middleCategoryId) {

        ProductDTO product = new ProductDTO();
        product.setProductName(productName);
        product.setPrice(price);
        product.setStockQuantity(stockQuantity);
        product.setCategoryId(middleCategoryId); // ← 여기에 중분류 ID 넣는 게 핵심

        productService.addProduct(product);
        return "redirect:/product/";
    }

    @GetMapping("/search")
    public String searchProduct(@RequestParam("productName") String productName, Model model){
        List<ProductDTO> searchResult = productService.findProductByName(productName);
        List<ProductCategoryDTO> productCategory = productCategoryService.categorySelect();

        model.addAttribute("searchResult", searchResult);
        model.addAttribute("categoryList", productCategory);
        return "product";
    }


    // 발주 카테고리별 상품 조회 young
    @GetMapping("/byCategory/{categoryId}")
    @ResponseBody
    public List<ProductDTO> getProductsByCategory(@PathVariable int categoryId) {
        return productService.findByCategoryId(categoryId);
    }

    @GetMapping("/stockQuantity")
    public String stockQuantity(Model model) {
        List<StockQuantityDTO> stockQuantityList = productService.stockQuantityList();
        model.addAttribute("stockQuantityList", stockQuantityList);

        return "stockQuantity";
    }


//    @GetMapping("/delete")
//    public String productDelete(@RequestParam("id") int productId) {
//        System.out.println("delete?" + productId);
//        productService.delete(productId);
//        return "redirect:/product/";
//    }

}
