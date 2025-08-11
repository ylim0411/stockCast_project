package com.spring.stockCast.service;

import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.dto.StockQuantityDTO;
import com.spring.stockCast.repository.ProductCategoryRepository;
import com.spring.stockCast.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ProductCategoryService {
    private final ProductCategoryRepository productCategoryRepository;
    private final ProductRepository productRepository;

    public List<ProductCategoryDTO> categorySelect(int storeId) {
        List<ProductCategoryDTO> categoryAll = productCategoryRepository.categorySelect();

        Map<Integer, ProductCategoryDTO> categoryMap = new HashMap<>();
        for (ProductCategoryDTO productCategory : categoryAll) {
            categoryMap.put(productCategory.getCategoryId(), productCategory);
        }

        List<ProductCategoryDTO> parentCategory = new ArrayList<>();

        for (ProductCategoryDTO productCategory : categoryAll){
            if(productCategory.getParentId() == null) {
                parentCategory.add(productCategory);
            }else {
                ProductCategoryDTO parent   = categoryMap.get(productCategory.getParentId().intValue());
                if (parent != null){
                    if (parent.getCategoryList() == null) {
                        parent.setCategoryList(new ArrayList<>());
                    }
                    parent.getCategoryList().add(productCategory);
                }
            }

            if (productCategory.getCategoryLevel() == 2) {
                List<ProductDTO> products = productRepository.selectProductsByCategoryId(productCategory.getCategoryId(),storeId);
                if (products != null && !products.isEmpty()) {
                    productCategory.setProductList(products);
                }
            }
        }

        return parentCategory;
    }

    // 발주 대분류 (거래처별) young
    public List<ProductCategoryDTO> findTopCategoriesByClient(int clientId) {
        return productCategoryRepository.findTopCategoriesByClient(clientId);
    }

    // 발주 중분류 (대분류 + 거래처별) young
    public List<ProductCategoryDTO> findSubCategoriesByParentIdAndClientId(int parentId, int clientId) {
        return productCategoryRepository.findSubCategoriesByParentIdAndClientId(parentId, clientId);
    }

    public List<StockQuantityDTO> categoryList() {
        return productCategoryRepository.categoryList();
    }

    // 대분류, 중분류 저장 (추가)
    public void saveCategory(ProductCategoryDTO categoryDTO) {
        productCategoryRepository.save(categoryDTO);
    }

    // 소분류(상품) 저장 (추가)
    public void saveProduct(ProductDTO productDTO) {
        productRepository.addCategory(productDTO);
    }

    // 모든 대분류 카테고리 조회 (추가)
    public List<ProductCategoryDTO> findTopLevelCategories() {
        return productCategoryRepository.findTopLevelCategories();
    }

    // 특정 대분류의 중분류 카테고리 조회 (추가)
    public List<ProductCategoryDTO> findMiddleLevelCategoriesByParentId(int parentId) {
        return productCategoryRepository.findMiddleLevelCategoriesByParentId(parentId);
    }

    public void updateCategoryNameByLevel(int categoryId, String newName, int level) {
        productCategoryRepository.updateCategoryNameByLevel(categoryId, newName, level);
    }
}
