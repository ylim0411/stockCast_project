package com.spring.stockCast.repository;

import com.spring.stockCast.dto.ClientDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class ClientRepository {
    private final SqlSessionTemplate sql;

    public ClientDTO findBySaleId(int id) {
        return sql.selectOne("Client.findBySaleId",id);
    }
}
