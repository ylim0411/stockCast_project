package com.spring.stockCast.service;

import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.repository.ProductCategoryRepository;
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

    public List<ProductCategoryDTO> categorySelect() {
        List<ProductCategoryDTO> categoryDTOList = productCategoryRepository.categorySelect();

        Map<Integer, ProductCategoryDTO> categoryDTOMap = new HashMap<>();
        for (ProductCategoryDTO productCategory : categoryDTOList) {
            categoryDTOMap.put(productCategory.getCategoryId(), productCategory);
        }

        List<ProductCategoryDTO> categoryList = new ArrayList<>();

        for (ProductCategoryDTO productCategory : categoryDTOList){
            if(productCategory.getParentId() == null) {
                categoryList.add(productCategory);
            }else {

            }
        }

        return categoryList;
    }
}
