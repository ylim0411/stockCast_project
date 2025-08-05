package com.spring.stockCast.service;


import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.repository.ProductCategoryRepository;
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
        return productRepository.findProductByName(productName);
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
}
