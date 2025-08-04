<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>발주서 수정</title>
    <script src="${pageContext.request.contextPath}/static/js/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
</head>
<body>
<div class="container">
    <div class="title-box">
        <p class="sub-title">발주 관리</p>
        <h2 class="title">발주서 수정</h2>
    </div>

    <div>
        <form id="orderUpdate" action="/order/orderUpdate" method="post">

            <!-- 숨겨진 필드 -->
            <input type="hidden" name="orderId" id="orderIdHidden" value="${orderInfo.orderId}">
            <input type="hidden" name="orderDate" id="orderDateHidden" value="<fmt:formatDate value='${orderInfo.orderDate}' pattern='yyyy-MM-dd'/>">
            <input type="hidden" name="clientId" value="${orderInfo.clientId}">

            <!-- 저장 -->
            <input type="submit" id="updateOrder" class="btn btn-blue" value="수정 완료">

            <!-- 거래처 -->
            <table class="clientsName">
                <tr>
                    <th class="vertical-label"><div>거래처명</div></th>
                    <td>
                        <input type="text" value="${orderInfo.clientName}" readonly class="readonly-input">
                    </td>
                </tr>
            </table>

            <!-- 발주 요약 -->
            <table class="orderSummary" aria-label="발주 요약">
                <tbody>
                <tr>
                    <th class="vertical-label"><div>발주번호</div></th>
                    <td>${orderInfo.orderId}</td>
                    <th class="vertical-label"><div>발주등록일</div></th>
                    <td><fmt:formatDate value="${orderInfo.orderDate}" pattern="yyyy-MM-dd"/></td>
                </tr>
                <tr>
                    <th class="vertical-label"><div>수량</div></th>
                    <td><input type="text" id="sum-quantity" readonly value="${orderInfo.totalCount}"></td>
                    <th class="vertical-label"><div>총금액</div></th>
                    <td><input type="text" id="sum-total" readonly value="<fmt:formatNumber value='${orderInfo.totalPrice}'/>"></td>
                </tr>
                </tbody>
            </table>

            <div class="btn-box">
                <button type="button" class="add-row btn btn-blue">행 추가</button>
                <button type="button" id="delete-selected" class="btn btn-red">선택 삭제</button>
            </div>

            <!-- 발주 상세 -->
            <table class="orderItems" aria-label="상세 상품 목록">
                <thead>
                <tr>
                    <th><input type="checkbox" id="select-all" /></th>
                    <th>상품명</th>
                    <th>구매단가</th>
                    <th>수량</th>
                    <th>총 금액</th>
                </tr>
                </thead>
                <tbody>

                <!-- 기존 발주 항목 -->
                <c:forEach var="item" items="${orderItems}">
                    <tr class="item-row">
                        <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                        <td>
                            <select name="productId[]" class="item-select">
                                <option value="">상품을 선택하세요</option>
                                <c:forEach var="p" items="${products}">
                                    <option value="${p.productId}" data-price="${p.price}"
                                        <c:if test="${p.productId == item.productId}">selected</c:if>>
                                        ${p.productName}
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                        <td>
                            <input type="number" name="purchasePrice_display" class="price-input" readonly
                                   value="${item.purchasePrice}" />
                            <input type="hidden" name="purchasePrice[]" class="price-hidden" value="${item.purchasePrice}" />
                        </td>
                        <td>
                            <input type="number" name="purchaseQty_display" class="count-input" min="0"
                                   value="${item.purchaseQty}" />
                            <input type="hidden" name="purchaseQty[]" class="qty-hidden" value="${item.purchaseQty}" />
                        </td>
                        <td>
                            <input type="text" name="total" class="total-display" readonly
                                   value="<fmt:formatNumber value='${item.purchasePrice * item.purchaseQty}'/>" />
                        </td>
                    </tr>
                </c:forEach>

                <!-- 숨겨진 템플릿 행 (신규 추가용) -->
                <tr class="item-row template" style="display:none;">
                    <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                    <td>
                        <select name="productId[]" class="item-select">
                            <option value="">상품을 선택하세요</option>
                            <c:forEach var="p" items="${products}">
                                <option value="${p.productId}" data-price="${p.price}">
                                    ${p.productName}
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <input type="number" name="purchasePrice_display" class="price-input" readonly />
                        <input type="hidden" name="purchasePrice[]" class="price-hidden" />
                    </td>
                    <td>
                        <input type="number" name="purchaseQty_display" class="count-input" min="0" />
                        <input type="hidden" name="purchaseQty[]" class="qty-hidden" />
                    </td>
                    <td><input type="text" name="total" class="total-display" readonly /></td>
                </tr>

                </tbody>
            </table>
        </form>
    </div>
</div>

<script>
$(document).ready(function(){

    $('#orderUpdate').on('submit', function(){
        $('.item-row').each(function(){
            if (!$(this).find('.item-select').val()) {
                $(this).remove();
            }
        });
    });

    // 가격 입력값이 변경될 때 hidden 필드에 값 복사
    $(document).on('input change', '.price-input', function() {
        $(this).siblings('.price-hidden').val($(this).val());
    });

    // 수량 입력값이 변경될 때 hidden 필드에 값 복사
    $(document).on('input change', '.count-input', function() {
        $(this).siblings('.qty-hidden').val($(this).val());
    });

    // 거래처 변경 시 hidden 값 업데이트
    $('#clientSelect').on('change', function(){
        $('#clientIdHidden').val($(this).val());
    });

    // 상품 선택 시 가격 반영
    $(document).on('change', '.item-select', function(){
        setPriceBySelected($(this));
        calcSummary();
    });

    // 수량 입력 시 합계 반영
    $(document).on('input', '.count-input', function(){
        let $row = $(this).closest('tr');
        calcRowTotal($row);
        calcSummary();
    });

    // 행 추가 버튼
    $('.add-row').click(function(){
        let $newRow = $('.template').clone().removeClass('template').show();
        $newRow.find('input').val('');
        $('table.orderItems tbody').append($newRow);
    });

    // 선택 삭제 버튼
    $('#delete-selected').click(function(){
        $('.row-select:checked').closest('tr').not('.template').remove();
        calcSummary();
    });

    // 전체 선택 체크박스
    $('#select-all').change(function(){
        $('.row-select').prop('checked', $(this).prop('checked'));
    });

    function setPriceBySelected($select){
        let $row = $select.closest('tr');
        let price = $select.find(':selected').data('price') || 0;
        $row.find('.price-input').val(price);
        $row.find('.price-hidden').val(price);
        calcRowTotal($row);
    }

    function calcRowTotal($row){
        let price = parseFloat($row.find('.price-input').val()) || 0;
        let count = parseInt($row.find('.count-input').val()) || 0;
        let total = price * count;
        $row.find('.total-display').val(total.toLocaleString());
        $row.find('.qty-hidden').val(count);
    }

    function calcSummary(){
        let totalQuantity = 0;
        let totalAmount = 0;
        $('.item-row').not('.template').each(function(){
            let count = parseInt($(this).find('.count-input').val()) || 0;
            let rowTotal = parseFloat(($(this).find('.total-display').val() || '0').replace(/,/g,'')) || 0;
            totalQuantity += count;
            totalAmount += rowTotal;
        });
        $('#sum-quantity').val(totalQuantity);
        $('#sum-total').val(totalAmount.toLocaleString());
    }
});
</script>

</body>
</html>
