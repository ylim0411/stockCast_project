package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AdminDTO;
import com.spring.stockCast.dto.StoreDTO;
import com.spring.stockCast.service.StoreService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/store")
public class StoreController {
    private final StoreService storeService;

    @PostMapping("/save")
    public String save(@ModelAttribute StoreDTO storeDTO, HttpSession session, Model model) {
        AdminDTO adminDTO = (AdminDTO) session.getAttribute("loginedAdminDTO");
        storeDTO.setAdminId(adminDTO.getAdminId());
        storeService.save(storeDTO);
        return "redirect:/mypage/";
    }
    @PostMapping("/update")
    public String update(@ModelAttribute StoreDTO storeDTO, HttpSession session, Model model) {

        storeService.update(storeDTO);
        return "redirect:/mypage/";
    }

    @PostMapping("/setSelectedStoreId")
    public void setSelectedStore(@RequestParam("storeId") String storeId, HttpSession session) {
        System.out.println(storeId);
        try {
            int storeIdInt = Integer.parseInt(storeId);
            session.setAttribute("selectedStoredId", storeIdInt);
        } catch (NumberFormatException e) {
            // 적절히 예외 처리 or 무시
        }
    }
    @PostMapping("/isUnique")
    @ResponseBody
    public boolean setSelectedStore(@RequestParam("storeName") String storeName) {
        boolean isUnique = false;
        try {
            isUnique = storeService.isUnique(storeName);
        } catch (NumberFormatException e) {
            // 적절히 예외 처리 or 무시
        }
        return isUnique;
    }
}
