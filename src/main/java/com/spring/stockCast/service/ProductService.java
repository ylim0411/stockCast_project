package com.spring.stockCast.service;


import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
<<<<<<< HEAD
=======
import java.util.Map;
>>>>>>> e43a20ddd810cdea45e5ece2709ee52845370d3f

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;

<<<<<<< HEAD
    public List<ProductDTO> findProductList() {
        return productRepository.findProductList();
    }

    public void delete(int productId) {
        productRepository.delete(productId);
=======
    // 거래처 ID로 상품 목록 조회
    public List<Map<String, Object>> getProductsByClientId(int clientId) {
        return productRepository.findProductsByClientId(clientId);
>>>>>>> e43a20ddd810cdea45e5ece2709ee52845370d3f
    }
}
