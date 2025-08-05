package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AdminDTO;
import com.spring.stockCast.dto.StoreDTO;
import com.spring.stockCast.service.AdminService;
import com.spring.stockCast.service.StoreService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class MypageController {
    private final AdminService adminService;
    private final StoreService storeService;

    @GetMapping("/")
    public String mypageForm(HttpSession session, Model model) {
        AdminDTO adminDTO = (AdminDTO) session.getAttribute("loginedAdminDTO");
        List<StoreDTO> tmpstoreDTO = storeService.selectAll(adminDTO.getAdminId());
        model.addAttribute("storeList", tmpstoreDTO);
        return "mypage";
    }

}
