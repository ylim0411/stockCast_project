package com.spring.stockCast.service;

import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.repository.ClientRepository;
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
    private final ClientRepository clientRepository;

    public List<Map<String, Object>> getProductsByClientId(int clientId) {
        return productRepository.findProductsByClientId(clientId);
    }

    public List<Map<String, Object>> getAllProducts() {
        return productRepository.getAllProducts();
    }

    public List<ProductDTO> findProductList() {
        return productRepository.findProductList();
    }

    public void updateProduct(ProductDTO product) {
        productRepository.updateProduct(product);
    }

    public void addProduct(ProductDTO product) {
        productRepository.addProduct(product);
    }

    public List<ProductDTO> findProductByName(String productName) {
        if (productName == null || productName.trim().isEmpty()) {
            return productRepository.findProductList();
        }
        return productRepository.findProductByName("%" + productName + "%");
    }

    public List<ProductCategoryDTO> findTopCategoriesByClientId(int clientId) {
        return productCategoryRepository.findTopCategoriesByClient(clientId);
    }

    public List<ProductCategoryDTO> findSubCategoriesByParentIdAndClientId(int parentId, int clientId) {
        return productCategoryRepository.findSubCategoriesByParentIdAndClientId(parentId, clientId);
    }

    public List<ProductDTO> findByCategoryId(int categoryId) {
        return productRepository.findByCategoryId(categoryId);
    }

    public List<StockQuantityDTO> stockQuantityList(String keyword, int month, int storeId) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            if (month > 0) {
                return productRepository.findStockQuantityByKeywordAndMonth("%" + keyword + "%", month, storeId);
            }
            return productRepository.findStockQuantityByKeyword("%" + keyword + "%", storeId);
        } else if (month > 0) {
            return productRepository.findStockQuantityByMonth(month, storeId);
        }
        return productRepository.stockQuantityList(storeId);
    }

    public List<ProductDTO> findProductsByCategoryId(int parentId) {
        return productRepository.findProductsByCategoryId(parentId);
    }

    public void updateProductName(int productId, String newName) {
        productRepository.updateProductName(productId, newName);
    }

    public void addProductWithClient(ProductDTO product, int clientId) {
        clientRepository.addProductWithClient(clientId, product.getProductName(), product.getStoreId());
    }

    public void updateProductAndClient(ProductDTO product, int clientId) {
        productRepository.updateProduct(product);
        clientRepository.updateProductAndClient(clientId, product.getProductId());
    }
}
