package com.spring.stockCast.repository;

import com.spring.stockCast.dto.StoreDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class StoreRepository {
    private final SqlSessionTemplate sql;

    public List<StoreDTO> selectAll(int adminId) {
        return sql.selectList("Store.selectAll", adminId);
    }

    public void update(StoreDTO storeDTO) {
        sql.update("Store.update", storeDTO);
    }

    public void save(StoreDTO storeDTO) {
        sql.insert("Store.insert", storeDTO);
    }
    public int countByAdminId(int adminId, String searchKeyword) {
        java.util.Map<String, Object> paramMap = new java.util.HashMap<>();
        paramMap.put("adminId", adminId);
        paramMap.put("searchKeyword", searchKeyword);
        return sql.selectOne("Store.countByAdminId", paramMap);
    }

    public List<StoreDTO> selectPageByAdminId(int adminId, int offset, int limit, String searchKeyword) {
        java.util.Map<String, Object> paramMap = new java.util.HashMap<>();
        paramMap.put("adminId", adminId);
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        paramMap.put("searchKeyword", searchKeyword);
        return sql.selectList("Store.selectPageByAdminId", paramMap);
    }
}
