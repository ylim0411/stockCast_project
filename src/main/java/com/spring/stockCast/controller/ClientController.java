package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AdminDTO;
import com.spring.stockCast.dto.ClientDTO;
import com.spring.stockCast.dto.PageDTO;
import com.spring.stockCast.dto.StoreDTO;
import com.spring.stockCast.enums.ClientStatus;
import com.spring.stockCast.service.ClientService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/client")
public class ClientController {
    private final ClientService clientService;

    @GetMapping("/")
    public String clientForm(
            HttpSession session,
            @RequestParam(value = "page", defaultValue = "1") int page,
            Model model) {

        AdminDTO adminDTO = (AdminDTO) session.getAttribute("loginedAdminDTO");

        int pageLimit = 10; // 한 페이지에 보여줄 항목 수
        int start = (page - 1) * pageLimit;

        // 전체 수
        int total = clientService.countByAdminId(adminDTO.getAdminId());

        // 페이징 정보
        PageDTO pageDTO = clientService.pagingParamWithSearch(page, total);

        // 현재 페이지 데이터 조회
        List<ClientDTO> tmpClientDTOs = clientService.selectPagingByAdminId(adminDTO.getAdminId(), start, pageLimit);

        model.addAttribute("clientList", tmpClientDTOs);
        model.addAttribute("paging", pageDTO);

        return "client";
    }

    @GetMapping("/filter")
    public String filterClients(@RequestParam("searchKeyword") String keyword,
                                @RequestParam(value = "page", defaultValue = "1") int page,
                                HttpSession session,
                                Model model) {
        AdminDTO adminDTO = (AdminDTO) session.getAttribute("loginedAdminDTO");
        int adminId = adminDTO.getAdminId();

        int total = clientService.countClientsByKeyword(adminId, keyword);
        int boardLimit = 10;
        int start = (page - 1) * boardLimit;

        List<ClientDTO> clientList = clientService.searchClientsWithPaging(adminId, keyword, start, boardLimit);
        PageDTO paging = clientService.pagingParamWithSearch(page, total);

        model.addAttribute("clientList", clientList);
        model.addAttribute("searchKeyword", keyword);
        model.addAttribute("paging", paging);

        return "client"; // client.jsp
    }


    @PostMapping("/add")
    public String add(@ModelAttribute ClientDTO clientDTO, Model model, HttpSession session) {
        AdminDTO adminDTO = (AdminDTO) session.getAttribute("loginedAdminDTO");
        clientDTO.setCreatedAt(LocalDateTime.now());
        clientDTO.setUpdatedAt(LocalDateTime.now());
        clientDTO.setAdminId(adminDTO.getAdminId());
        if (clientDTO.getStatus() == ClientStatus.정상)
        {
            clientDTO.setDeletedAt(null);
        }
        else
        {
            clientDTO.setDeletedAt(LocalDateTime.now());
        }

        System.out.println(clientDTO);
        if (clientService.insert(clientDTO))
        {
            List<ClientDTO> tmpClientDTOs = clientService.selectByAdminId(adminDTO.getAdminId());
            model.addAttribute("clientList", tmpClientDTOs);
            System.out.println(tmpClientDTOs);
            return "client";
        }
        return "redirect:/client/";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute ClientDTO clientDTO, Model model, HttpSession session) {
        ClientDTO beforClientDTO = clientService.selectByClientId(clientDTO.getClientId());
        clientDTO.setUpdatedAt(LocalDateTime.now());
        if (clientDTO.getStatus() == ClientStatus.정상)
        {
            clientDTO.setDeletedAt(null);
        }
        else if (clientDTO.getStatus() == ClientStatus.중지 && beforClientDTO.getStatus() == ClientStatus.정상)
        {
            clientDTO.setDeletedAt(LocalDateTime.now());
        }

        System.out.println(clientDTO);
        if (clientService.update(clientDTO))
        {
            AdminDTO adminDTO = (AdminDTO) session.getAttribute("loginedAdminDTO");
            List<ClientDTO> tmpClientDTOs = clientService.selectByAdminId(adminDTO.getAdminId());
            model.addAttribute("clientList", tmpClientDTOs);
            System.out.println(tmpClientDTOs);
            return "client";
        }
        return "redirect:/client/";
    }
}
