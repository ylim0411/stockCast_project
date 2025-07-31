package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AccountingDTO;
import com.spring.stockCast.service.AccountingService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/accounting")
public class AccountingController {
    private final AccountingService accountingService;

    @GetMapping("/")
    public String listForm(Model model){
        List<AccountingDTO> accountList = accountingService.findAll();
        model.addAttribute("accountList",accountList);
        return "accounting";
    }
}
@RestController
@RequestMapping("/accounting")
class AccountingAjax {

    @GetMapping("/hello")
    public String Ajax(){
        return "<div class=\"container\">\n" +
                "        <div class=\"accounting-header\">\n" +
                "          <h1>회계 관리</h1>\n" +
                "        </div>\n" +
                "        <div class=\"caption\">\n" +
                "          <input type=\"date\" name=\"startDate\"> ~\n" +
                "          <input type=\"date\" name=\"endDate\">\n" +
                "          <input type=\"text\" name=\"orderNumber\" placeholder=\"발주번호\">\n" +
                "          <button onclick=\"onSearch()\">검색</button>\n" +
                "          <button class=\"btn btn-primary\" type=\"submit\">Button</button></br>\n" +
                "        </div>\n" +
                "         <table>\n" +
                "                <tr>\n" +
                "                    <th>발주번호</th>\n" +
                "                    <th>발주일자</th>\n" +
                "                    <th>거래처명</th>\n" +
                "                    <th>상품명</th>\n" +
                "                    <th>총금액</th>\n" +
                "                    <th>보고서</th>\n" +
                "                </tr>\n" +
                "                <c:forEach items=\"${accountList}\" var=\"account\">\n" +
                "                    <tr>\n" +
                "                        <td>${account.orderId}</td>\n" +
                "                        <td>\n" +
                "                            <a href=\"/account?id=${account.orderId}\"> ${account.transactionDate}</a>\n" +
                "                        </td>\n" +
                "                        <td>${account.salesAmount}</td>\n" +
                "                        <td>${account.netProfit}</td>\n" +
                "                        <td>${account.cost}</td>\n" +
                "                        <td><button onclick=\"#\">${account.income}</button></td>\n" +
                "                    </tr>\n" +
                "                </c:forEach>\n" +
                "            </table>\n" +
                "    </div>";
    }
}