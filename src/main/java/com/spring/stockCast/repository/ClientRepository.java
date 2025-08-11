package com.spring.stockCast.repository;

import com.spring.stockCast.dto.ClientDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class ClientRepository {
    private final SqlSessionTemplate sql;
    // 발주번호 일치하는 거래처 조회
    public ClientDTO findBySaleId(int id) {
        return sql.selectOne("Client.findBySaleId",id);
    }

    // 해당 storeId의 모든 거래처 목록 조회 young
    public List<ClientDTO> selectByStoreId(int storeId) {
        return sql.selectList("Client.selectByStoreId", storeId);
    }

    // 해당 clientId가 존재하는지 여부 조회 young
    public int countByStoreIdAndClientId(int storeId, int clientId) {
        Map<String, Object> p = new HashMap<>();
        p.put("storeId", storeId);
        p.put("clientId", clientId);
        return sql.selectOne("Client.countByStoreIdAndClientId", p);
    }

    public List<ClientDTO> selectByAdminId(int adminId) {
        return sql.selectList("Client.selectByAdminId",adminId);
    }

    public boolean update(ClientDTO clientDTO) {
        return sql.update("Client.update", clientDTO) > 0;
    }

    public ClientDTO selectByClientId(int clientId) {
        return sql.selectOne("Client.selectByClientId",clientId);
    }

    public boolean insert(ClientDTO clientDTO) {
        return sql.insert("Client.insert", clientDTO) > 0;
    }

    public List<ClientDTO> selectPagingByAdminId(Map<String, Object> param) {
        return sql.selectList("Client.selectPagingByAdminId", param);
    }

    public int countByAdminId(int adminId) {
        return sql.selectOne("Client.countByAdminId", adminId);
    }
    // 검색 키워드로 거래처 목록 페이징 조회
    public List<ClientDTO> searchClientsWithPaging(Map<String, Object> param) {
        return sql.selectList("Client.searchClientsWithPaging", param);
    }

    // 검색 키워드로 거래처 수 조회
    public int countClientsByKeyword(Map<String, Object> param) {
        return sql.selectOne("Client.countClientsByKeyword", param);
    }

}
