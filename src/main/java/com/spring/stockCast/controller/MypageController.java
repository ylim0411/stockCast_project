package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AdminDTO;
import com.spring.stockCast.dto.PageDTO;
import com.spring.stockCast.dto.StoreDTO;
import com.spring.stockCast.service.AdminService;
import com.spring.stockCast.service.StoreService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class MypageController {
    private final StoreService storeService;

    @GetMapping("/")
    public String mypageForm(
            @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
            @RequestParam(value = "page", defaultValue = "1") int page,
            HttpSession session,
            Model model) {
        if (searchKeyword == null) {
            searchKeyword = "";
        }

        AdminDTO adminDTO = (AdminDTO) session.getAttribute("loginedAdminDTO");
        if (adminDTO == null) {
            return "redirect:/admin/login"; // 로그인 안 되어 있으면 로그인 페이지로
        }

        int pageSize = 4; // 한 페이지에 보여줄 점포 수
        int totalCount = storeService.countByAdminId(adminDTO.getAdminId(),searchKeyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        if (page > totalPages)
        {
            page = totalPages;
        }
        if (page < 1)
        {
            page = 1;
        }

        int offset = (page - 1) * pageSize;

        List<StoreDTO> storeList = storeService.selectPageByAdminId(adminDTO.getAdminId(), offset, pageSize, searchKeyword);

        // 페이징 정보 생성
        PageDTO paging = new PageDTO();
        paging.setPage(page);
        paging.setMaxPage(totalPages);
        paging.setStartPage(1);
        paging.setEndPage(totalPages);

        model.addAttribute("storeList", storeList);
        model.addAttribute("paging", paging);
        model.addAttribute("searchKeyword", searchKeyword);

        return "mypage";
    }

}
