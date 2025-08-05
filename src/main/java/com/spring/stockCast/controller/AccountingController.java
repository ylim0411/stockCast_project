package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AccountItemDTO;
import com.spring.stockCast.enums.Direction;
import com.spring.stockCast.service.AccountingService;
import lombok.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/accounting")
public class AccountingController {
    private final AccountingService accountingService;

    @GetMapping("/list") //페이지 이동 시 목록 불러오기
    public String accountingList(@RequestParam(required = false) String startDate,
                                 @RequestParam(required = false) String endDate,
                                 Model model) {

        List<AccountItemDTO> AllList = accountingService.findAll(); // 판매 발주 목록 전체가져오기
        List<AccountItemDTO> assetList = new ArrayList<>(); // 차변값 넣는 리스트
        List<AccountItemDTO> liabilityList = new ArrayList<>(); // 대변값 넣는 리스트
        for(AccountItemDTO item : AllList){
            if(item.getDirection().equals(Direction.차변)){
                assetList.add(item);
            }else {
                liabilityList.add(item);
            }
        }

        model.addAttribute("assetList", assetList);
        model.addAttribute("liabilityList", liabilityList);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("totalAsset", 1000000);
        model.addAttribute("totalLiability", 0);

        return "accounting";
    }
    @PostMapping("/list")
    public String findAccounting(){
        return "accounting";
    }
}