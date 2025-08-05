package com.spring.stockCast.service;

import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.dto.ProductDTO;
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

    public List<ProductCategoryDTO> categorySelect() {
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
                List<ProductDTO> products = productRepository.selectProductsByCategoryId(productCategory.getCategoryId());
                if (products != null && !products.isEmpty()) {
                    productCategory.setProductList(products);
                }
            }
        }

        return parentCategory;
    }

    public List<ProductCategoryDTO> findAllCategory() {
        return productCategoryRepository.categorySelect();
    }

    // 발주 대분류 (거래처별) young
    public List<ProductCategoryDTO> findTopCategoriesByClient(int clientId) {
        return productCategoryRepository.findTopCategoriesByClient(clientId);
    }

    // 발주 중분류 (대분류 + 거래처별) young
    public List<ProductCategoryDTO> findSubCategoriesByParentIdAndClientId(int parentId, int clientId) {
        return productCategoryRepository.findSubCategoriesByParentIdAndClientId(parentId, clientId);
    }

}
