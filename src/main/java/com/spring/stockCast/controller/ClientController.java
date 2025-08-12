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
    public String clientForm(@RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                             @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                             HttpSession session,
                             Model model) {
        AdminDTO adminDTO = (AdminDTO) session.getAttribute("loginedAdminDTO");
        int storeId = (int) session.getAttribute("selectedStoredId");
        int adminId = adminDTO.getAdminId();

        if (searchKeyword == null) {
            searchKeyword = "";
        }

        int total = clientService.countClientsByKeyword(storeId, searchKeyword);
        int boardLimit = 10;
        int start = (page - 1) * boardLimit;

        List<ClientDTO> clientList = clientService.searchClientsWithPaging(storeId, searchKeyword, start, boardLimit);
        PageDTO paging = clientService.pagingParamWithSearch(page, total);

        model.addAttribute("clientList", clientList);
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("paging", paging);

        return "client";
    }


    @PostMapping("/add")
    public String add(@ModelAttribute ClientDTO clientDTO, Model model, HttpSession session) {
        AdminDTO adminDTO = (AdminDTO) session.getAttribute("loginedAdminDTO");
        int storeId = (int) session.getAttribute("selectedStoredId");
        clientDTO.setStoreId(storeId);
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
        clientService.insert(clientDTO);
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
        clientService.update(clientDTO);
        return "redirect:/client/";
    }
}
