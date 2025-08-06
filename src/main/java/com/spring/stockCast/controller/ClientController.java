package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AdminDTO;
import com.spring.stockCast.dto.ClientDTO;
import com.spring.stockCast.dto.StoreDTO;
import com.spring.stockCast.enums.ClientStatus;
import com.spring.stockCast.service.ClientService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

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
    public String clientForm(HttpSession session, Model model) {
        AdminDTO adminDTO = (AdminDTO) session.getAttribute("loginedAdminDTO");
        List<ClientDTO> tmpClientDTOs = clientService.selectByAdminId(adminDTO.getAdminId());
        model.addAttribute("clientList", tmpClientDTOs);
        return "client";
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
