package com.spring.stockCast.service;

import com.spring.stockCast.dto.CustomerDTO;
import com.spring.stockCast.enums.Gender;
import com.spring.stockCast.repository.CustomerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CustomerService {
    private final CustomerRepository customerRepository;

    // 고객정보 조회 ho
    public List<CustomerDTO> findAll(String storeId) {
        return customerRepository.findAll(storeId);
    }

    // 고객 성별 및 연령대 반환 ho
    public Map<String,Integer> findCustomer(HttpSession session){
        String storeId = session.getAttribute("selectedStoredId").toString(); // StoreController 에서 저장한 id 받아오기
        Map<String,Integer> result = new HashMap<>();
        List<CustomerDTO> customers = findAll(storeId);
        int man=0,woman =0,etc=0;
        int age_10=0,age_20=0,age_30=0,age_40=0,ageEtc=0;
        for (CustomerDTO customer : customers){
            // 성별 조회
            if(customer.getGender().equals(Gender.남)){
                man++;
            }else if(customer.getGender().equals(Gender.여)){
                woman++;
            }else{
                etc++;
            }
            // 연령대 조회 추후 연령대 추가시 밑에 늘리면 됨
            if(customer.getAge() >= 10 && customer.getAge() <20){
                age_10++;
            }else if(customer.getAge() >= 20 && customer.getAge() <30){
                age_20++;
            }else if(customer.getAge() >= 30 && customer.getAge() <40){
                age_30++;
            }else if(customer.getAge() >= 40 && customer.getAge() <120){
                age_40++;
            }else{
                ageEtc++;
            }
        }
        result.put("man",man);
        result.put("woman",woman);
        result.put("etc",etc);
        result.put("age_10",age_10);
        result.put("age_20",age_20);
        result.put("age_30",age_30);
        result.put("age_40",age_40);
        result.put("ageEtc",ageEtc);
        return result;
    }
}
