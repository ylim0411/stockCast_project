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

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/productCategory")
public class ProductCategoryController {
    private final ProductCategoryService productCategoryService;
    private final ProductService productService;

    // 카테고리 목록 조회
    @GetMapping("/list")
    public String categoryList(Model model, HttpSession session) {
        int storeId = (int) session.getAttribute("selectedStoredId");

        List<StockQuantityDTO> categoryList = productCategoryService.categoryList(storeId);
//        List<ProductCategoryDTO> topList = productCategoryService.findTopLevelCategories(storeId);
        List<ProductCategoryDTO> topList = productCategoryService.findTopLevelCategories(storeId);

        model.addAttribute("categoryList", categoryList);
        model.addAttribute("topList", topList);

        return "productCategory";
    }

    // 카테고리 추가 등록
    @PostMapping("/save")
    public String categorySave(@RequestParam("categoryLevel") int categoryLevel,
                               @RequestParam("categoryName") String categoryName,
                               @RequestParam(value = "parentId", required = false) Integer parentId,
                               @RequestParam(value = "middleParentId", required = false) Integer middleParentId,
                               RedirectAttributes redirectAttributes,
                               HttpSession session) {
        int storeId = (int) session.getAttribute("selectedStoredId");

        try {
            if (categoryLevel == 3) {
                ProductDTO productDTO = new ProductDTO();
                productDTO.setStoreId(storeId);
                productDTO.setProductName(categoryName);
                productDTO.setCategoryId(parentId); // 중분류 ID
                productCategoryService.saveProduct(productDTO);
            } else {
                ProductCategoryDTO categoryDTO = new ProductCategoryDTO();
                categoryDTO.setStoreId(storeId);
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
    public List<ProductCategoryDTO> getTopCategories(HttpSession session) {
        int storeId = (int) session.getAttribute("selectedStoredId");
        return productCategoryService.findTopLevelCategories(storeId);
    }



    // 중분류 목록 조회 (모달용) (추가)
    @GetMapping("/middleCategories")
    @ResponseBody
    public List<ProductCategoryDTO> getMiddleCategories(@RequestParam int parentId, HttpSession session) {
        int storeId = (int) session.getAttribute("selectedStoredId");
        return productCategoryService.findMiddleLevelCategoriesByParentId(parentId, storeId);
    }
    
    // 소분류 등록
    @PostMapping("/saveProduct")
    @ResponseBody
    public String saveProductAjax(@RequestParam("categoryId") int categoryId,
                                  @RequestParam("productName") String productName,
                                  @RequestParam("storeId") int storeId) {
        try {
            ProductDTO productDTO = new ProductDTO();
            productDTO.setStoreId(storeId);
            productDTO.setCategoryId(categoryId); // 중분류 ID
            productDTO.setProductName(productName);
            productDTO.setPrice(0);
            productDTO.setStockQuantity(0);
            productCategoryService.saveProduct(productDTO);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }


    @GetMapping("/childCategories")
    @ResponseBody
    public List<ProductDTO> getChildCategories(@RequestParam int parentId) {
        return productService.findProductsByCategoryId(parentId);
    }

    // 모달 카테고리 이름 수정 요청 처리 (추가/수정)
    @PostMapping("/updateCategoryName")
    @ResponseBody
    public String updateCategoryName(@RequestParam("id") int id,
                                     @RequestParam("type") String type,
                                     @RequestParam("newName") String newName) {
        try {
            if("top".equals(type)) {
                productCategoryService.updateCategoryNameByLevel(id, newName, 1);
            } else if ("middle".equals(type)) {
                productCategoryService.updateCategoryNameByLevel(id, newName, 2);
            } else if ("product".equals(type)) {
                productService.updateProductName(id, newName);
            } else {
                return "error";
            }
            return "success";
        } catch (Exception e) {
            return "error";
        }
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


    // ProductCategoryController.java

    @PostMapping("/saveAjax")
    @ResponseBody
    public Map<String, Object> saveAjax(@RequestParam("categoryLevel") int categoryLevel,
                                        @RequestParam("categoryName") String categoryName,
                                        @RequestParam(value = "parentId", required = false) Integer parentId,
                                        HttpSession session) {
        int storeId = (int) session.getAttribute("selectedStoredId");
        Map<String, Object> res = new HashMap<>();
        try {
            if (categoryLevel == 3) {
                // 소분류(상품)은 별도 엔드포인트 사용 (아래 saveProductAjax)
                res.put("success", false);
                res.put("message", "Use /productCategory/saveProductAjax for level=3");
                return res;
            }

            ProductCategoryDTO dto = new ProductCategoryDTO();
            dto.setStoreId(storeId);
            dto.setCategoryName(categoryName);
            dto.setCategoryLevel(categoryLevel);
            if (parentId != null) dto.setParentId(Long.valueOf(parentId));

            // 저장 시 keyProperty(categoryId)가 채워지도록 서비스/매퍼 설정 필요
            productCategoryService.saveCategory(dto);

            res.put("success", true);
            res.put("id", dto.getCategoryId());   // auto-increment id
            res.put("name", dto.getCategoryName());
            res.put("createdAt", dto.getCreatedAt()); // 없으면 프론트에서 오늘날짜 사용
            return res;
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "카테고리 저장 실패");
            return res;
        }
    }

    @PostMapping("/saveProductAjax")
    @ResponseBody
    public Map<String, Object> saveProductAjax(@RequestParam("categoryId") int categoryId,
                                               @RequestParam("productName") String productName,
                                               HttpSession session) {
        int storeId = (int) session.getAttribute("selectedStoredId");
        Map<String, Object> res = new HashMap<>();
        try {
            ProductDTO p = new ProductDTO();
            p.setStoreId(storeId);
            p.setCategoryId(categoryId);
            p.setProductName(productName);
            p.setPrice(0);
            p.setStockQuantity(0);

            productCategoryService.saveProduct(p); // keyProperty(productId) 세팅되도록

            res.put("success", true);
            res.put("id", p.getProductId());
            res.put("name", p.getProductName());
            res.put("createdAt", p.getCreatedAt());
            return res;
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "상품 저장 실패");
            return res;
        }
    }


}
