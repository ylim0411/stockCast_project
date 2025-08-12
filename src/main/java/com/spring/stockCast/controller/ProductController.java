package com.spring.stockCast.controller;

import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.dto.StockQuantityDTO;
import com.spring.stockCast.service.ClientService;
import com.spring.stockCast.service.ProductCategoryService;
import com.spring.stockCast.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.stream.Collectors;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/product")
public class ProductController {
    private final ProductService productService;
    private final ProductCategoryService productCategoryService;
    private final ClientService clientService;

    @GetMapping("/byClient")
    @ResponseBody
    public List<Map<String, Object>> getProductsByClient(@RequestParam int clientId) {
        return productService.getProductsByClientId(clientId);
    }

    @GetMapping("/list")
    public String productList(Model model, HttpSession session,
                              @RequestParam(value = "productName", required = false) String productName) {
        int storeId = (int) session.getAttribute("selectedStoredId");
        if (productName == null) productName = "";

        List<ProductCategoryDTO> categoryList = productCategoryService.categorySelect(storeId, productName);

        model.addAttribute("categoryList", categoryList);
        model.addAttribute("clients", clientService.findByStoreId(storeId));
        System.out.println("storeId=" + storeId + " clients=" + clientService.findByStoreId(storeId));
        return "product";
    }

    @PostMapping("/update")
    public String updateProduct(@RequestParam("productId") Integer productId,
                                @RequestParam("productName") String productName,
                                @RequestParam("price") Integer price,
                                @RequestParam("stockQuantity") Integer stockQuantity,
                                @RequestParam("middleCategoryId") Integer middleCategoryId,
                                @RequestParam("clientId") Integer clientId,
                                HttpSession session) {

        // 서버 측 기본값/검증 (빈 문자열 -> null 로 들어온 경우 방어)
        if (productId == null || productName == null || productName.trim().isEmpty()
                || price == null || stockQuantity == null
                || middleCategoryId == null || clientId == null) {
            // 잘못된 요청은 목록으로 되돌리되, 필요 시 에러 파라미터를 추가할 수 있습니다.
            return "redirect:/product/list";
        }

        int storeId = (int) session.getAttribute("selectedStoredId");

        ProductDTO product = new ProductDTO();
        product.setProductId(productId);
        product.setStoreId(storeId);
        product.setProductName(productName.trim());
        product.setPrice(price);
        product.setStockQuantity(stockQuantity);
        product.setCategoryId(middleCategoryId);

        // 한 번만 업데이트(중복 호출 제거)
        productService.updateProductAndClient(product, clientId);

        return "redirect:/product/list";
    }

    @PostMapping("/add")
    public String addProduct(@RequestParam("addProductName") String productName,
                             @RequestParam("addPrice") Integer price,
                             @RequestParam("addStockQuantity") Integer stockQuantity,
                             @RequestParam("addMiddleCategoryId") Integer middleCategoryId,
                             @RequestParam("clientId") Integer clientId,
                             HttpSession session) {

        if (productName == null || productName.trim().isEmpty()
                || price == null || stockQuantity == null
                || middleCategoryId == null || clientId == null) {
            return "redirect:/product/list";
        }

        int storeId = (int) session.getAttribute("selectedStoredId");

        ProductDTO product = new ProductDTO();
        product.setStoreId(storeId);
        product.setProductName(productName.trim());
        product.setPrice(price);
        product.setStockQuantity(stockQuantity);
        product.setCategoryId(middleCategoryId);

        productService.addProduct(product);
        productService.addProductWithClient(product, clientId);

        return "redirect:/product/list";
    }

    @GetMapping("/search")
    public String searchProduct(@RequestParam("productName") String productName, Model model, HttpSession session){
        int storeId = (int) session.getAttribute("selectedStoredId");
        List<ProductCategoryDTO> productCategory = productCategoryService.categorySelect(storeId, productName);
        model.addAttribute("categoryList", productCategory);
        return "product";
    }

    @GetMapping("/byCategory/{categoryId}")
    @ResponseBody
    public List<ProductDTO> getProductsByCategory(@PathVariable int categoryId) {
        return productService.findByCategoryId(categoryId);
    }

    @GetMapping("/stockQuantity")
    public String stockQuantity(@RequestParam(value = "keyword", required = false) String keyword,
                                @RequestParam(value = "month", required = false) Integer month,
                                Model model, HttpSession session) {
        int storeId = (int) session.getAttribute("selectedStoredId");
        if (month == null) month = 0;
        List<StockQuantityDTO> stockQuantityList = productService.stockQuantityList(keyword, month, storeId);

        model.addAttribute("stockQuantityList", stockQuantityList);
        model.addAttribute("keyword", keyword);
        model.addAttribute("month", month);
        return "stockQuantity";
    }

    @GetMapping("/lowStock")
    @ResponseBody
    public List<StockQuantityDTO> getLowStockProducts(HttpSession session) {
        int storeId = (int) session.getAttribute("selectedStoredId");
        List<StockQuantityDTO> allStock = productService.stockQuantityList(null, -1, storeId);
        return allStock.stream()
                .filter(p -> p.getStockQuantity() != null && p.getStockQuantity() < 20)
                .collect(Collectors.toList());
    }
}
