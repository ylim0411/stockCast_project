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

import javax.servlet.http.HttpSession;
import java.util.stream.Collectors;

import java.time.LocalDate;
import java.time.YearMonth;
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
    public String productList(Model model, HttpSession session) {
        int storeId = (int) session.getAttribute("selectedStoredId");
        List<ProductCategoryDTO> categoryList = productCategoryService.categorySelect(storeId);
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
    public String searchProduct(@RequestParam("productName") String productName, Model model, HttpSession session){
        int storeId = (int) session.getAttribute("selectedStoredId");

        List<ProductDTO> searchResult = productService.findProductByName(productName);
        List<ProductCategoryDTO> productCategory = productCategoryService.categorySelect(storeId);

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

    // 재고현황
    @GetMapping("/stockQuantity")
    public String stockQuantity(@RequestParam(value = "keyword", required = false) String keyword,
                                @RequestParam(value = "month", required = false) Integer  month,
                                Model model) {
        if (month == null)
        {
            month = 0;
        }
        List<StockQuantityDTO> stockQuantityList = productService.stockQuantityList(keyword, month);

        model.addAttribute("stockQuantityList", stockQuantityList);
        model.addAttribute("keyword", keyword);
        model.addAttribute("month", month);

        return "stockQuantity";
    }


//    // 재고 현황 페이지
//    @GetMapping("/stockQuantity")
//    public String stockStatus(@RequestParam(required = false) Integer month,
//                              @RequestParam(required = false) String productName,
//                              Model model) {
//
//        // 월이 선택되지 않았을 경우, 현재 월을 기준으로 설정
//        if (month == null) {
//            month = LocalDate.now().getMonthValue();
//        }
//
//        // 조회 기간 설정
//        YearMonth yearMonth = YearMonth.now();
//        if (month != null) {
//            yearMonth = YearMonth.of(LocalDate.now().getYear(), month);
//        }
//        LocalDate startDate = yearMonth.atDay(1);
//        LocalDate endDate = yearMonth.atEndOfMonth();
//
//        List<StockQuantityDTO> stockList = productService.getStockQuantityList(startDate, endDate, productName);
//        model.addAttribute("stockList", stockList);
//        model.addAttribute("selectedMonth", month);
//        model.addAttribute("searchProductName", productName);
//        return "stockQuantity"; // JSP 파일명을 stockQuantity로 통일
//    }
//
//    // 재고 마감 처리 (POST 요청으로 변경)
//    @PostMapping("/closeStock")
//    @ResponseBody
//    public String closeStock() {
//        // 마감일은 다음달 1일로 설정
//        LocalDate closeDate = LocalDate.now().plusMonths(1).withDayOfMonth(1);
//
//        try {
//            // 마감 처리 로직 실행
//            productService.closeStockByDate(closeDate);
//            return "success";
//        } catch (Exception e) {
//            // 에러 발생 시 로그 기록 및 실패 반환
//            return "failure";
//        }
//    }



    @GetMapping("/lowStock")
    @ResponseBody
    public List<StockQuantityDTO> getLowStockProducts() {
        List<StockQuantityDTO> allStock = productService.stockQuantityList(null,-1);
        return allStock.stream()
                .filter(p -> p.getStockQuantity() != null && p.getStockQuantity() < 20)
                .collect(Collectors.toList());
    }

//    @GetMapping("/lowStock")
//    @ResponseBody
//    public List<StockQuantityDTO> getLowStockProducts() { // 수정
//        return productService.findLowStock();
//    }


}

