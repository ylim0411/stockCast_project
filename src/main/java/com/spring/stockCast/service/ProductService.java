package com.spring.stockCast.service;


import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.repository.ProductCategoryRepository;
import com.spring.stockCast.dto.StockQuantityDTO;
import com.spring.stockCast.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;
    private final ProductCategoryRepository productCategoryRepository;

    // 거래처 ID로 상품 목록 조회
    public List<Map<String, Object>> getProductsByClientId(int clientId) {
        return productRepository.findProductsByClientId(clientId);
    }

    public List<Map<String, Object>> getAllProducts() {
        return productRepository.getAllProducts();
    }

    public List<ProductDTO> findProductList() {
        return productRepository.findProductList();
    }

//    public void delete(int productId) {
//        productRepository.delete(productId);
//    }

    public void updateProduct(ProductDTO product) {
        productRepository.updateProduct(product);
    }

    public void addProduct(ProductDTO product) {
        productRepository.addProduct(product);
    }

    public List<ProductDTO> findProductByName(String productName) {
        if (productName == null || productName.trim().isEmpty()) {
            return productRepository.findProductList(); // 전체 조회
        }
        return productRepository.findProductByName("%" + productName + "%");
    }


    // 발주 카테고리별 상품 조회 young
    public List<ProductCategoryDTO> findTopCategoriesByClientId(int clientId) {
        return productCategoryRepository.findTopCategoriesByClient(clientId);
    }

    // 거래처별 대분류 조회 young
    public List<ProductCategoryDTO> findSubCategoriesByParentIdAndClientId(int parentId, int clientId) {
        return productCategoryRepository.findSubCategoriesByParentIdAndClientId(parentId, clientId);
    }

    // 발주 카테고리별 상품 조회 young
    public List<ProductDTO> findByCategoryId(int categoryId) {
        return productRepository.findByCategoryId(categoryId);
    }

    public List<StockQuantityDTO> stockQuantityList(String keyword, int month, int storeId) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            if (month > 0)
            {
                return productRepository.findStockQuantityByKeywordAndMonth("%" + keyword + "%", month,storeId);
            }
            return productRepository.findStockQuantityByKeyword("%" + keyword + "%",storeId);
        } else if (month > 0) {
            return productRepository.findStockQuantityByMonth(month,storeId);
        }
        return productRepository.stockQuantityList(storeId);
    }

    public List<ProductDTO> findProductsByCategoryId(int parentId) {
        return productRepository.findProductsByCategoryId(parentId);
    }

    public void updateProductName(int productId, String newName) {
        productRepository.updateProductName(productId, newName);
    }


//    // 재고 20개 이하 알림창 you
//    public List<StockQuantityDTO> findLowStock() { // 추가
//        return productRepository.findLowStock();
//    }

    // 재고 현황 조회 (기간 및 상품명으로 필터링)
//    public List<StockQuantityDTO> getStockQuantityList(LocalDate startDate, LocalDate endDate, String productName) {
//        // ProductRepository의 stockList 메서드를 호출합니다.
//        return productRepository.stockList(startDate, endDate, productName);
//    }
//
//    /**
//     * 재고 마감 처리를 수행합니다.
//     * 현재 상품 재고를 다음 달의 기초 재고로 설정합니다.
//     *
//     * @param closeDate 마감 처리 기준 날짜 (다음달 1일)
//     */
//    public void closeStockByDate(LocalDate closeDate) {
//        productRepository.closeStock(closeDate);
//    }

}
