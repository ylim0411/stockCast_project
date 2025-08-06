package com.spring.stockCast.dto;

import lombok.Builder;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
@Builder
public class AccountingDTO {
    private List<AccountItemDTO> assetsList;
    private List<AccountItemDTO> liabilitiesList;
    private List<AccountItemDTO> capitalList;
    private List<AccountItemDTO> revenueList;
    private List<AccountItemDTO> expenseList;
    private long totalDebit;
    private long totalCredit;
}
