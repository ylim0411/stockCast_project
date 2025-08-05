<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>발주서 수정</title>
    <script src="${pageContext.request.contextPath}/static/js/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
</head>
<body>
<div class="containerAuto">
    <div class="title-box">
        <p class="sub-title">발주 관리</p>
        <h2 class="title">발주서 수정</h2>
    </div>

    <div>
        <form id="orderUpdate" action="/order/orderUpdate" method="post">
            <!-- 숨겨진 필드 -->
            <input type="hidden" name="orderId" value="${orderInfo.orderId}">
            <input type="hidden" name="orderDate" value="<fmt:formatDate value='${orderInfo.orderDate}' pattern='yyyy-MM-dd'/>">
            <input type="hidden" name="clientId" value="${orderInfo.clientId}">

            <!-- 저장 버튼 -->
            <div class="btn-box">
                <input type="submit" class="btn submit-btn" value="수정">
            </div>

            <!-- 거래처 -->
            <table class="clientsName">
                <tr>
                    <th class="vertical-label"><div>거래처명</div></th>
                    <td><input type="text" value="${orderInfo.clientName}" readonly class="readonly-input"></td>
                </tr>
            </table>

            <!-- 발주 요약 -->
            <table class="orderSummary">
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

            <!-- 행 추가/삭제 -->
            <div class="btn-box" style="margin:20px;">
                <button type="button" class="add-row btn btn-blue">행 추가</button>
                <button type="button" id="delete-selected" class="btn btn-red">선택 삭제</button>
            </div>

            <!-- 발주 상세 -->
            <table class="orderItems">
                <thead>
                <tr>
                    <th><input type="checkbox" id="select-all" /></th>
                    <th>대분류</th>
                    <th>중분류</th>
                    <th>상품명</th>
                    <th>구매단가</th>
                    <th>수량</th>
                    <th>총 금액</th>
                </tr>
                </thead>
                <tbody>
                <!-- 기존 발주 항목 -->
                <c:forEach var="item" items="${orderItems}">
                    <tr class="item-row"
                        data-top-id="${item.topCategoryId}"
                        data-sub-id="${item.subCategoryId}"
                        data-product-id="${item.productId}">
                        <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                        <td><select class="top-category-select"><option value="">대분류 선택</option></select></td>
                        <td><select class="sub-category-select"><option value="">중분류 선택</option></select></td>
                        <td><select name="productId[]" class="item-select"><option value="">상품 선택</option></select></td>
                        <td>
                            <input type="number" name="purchasePrice_display" class="price-input" readonly value="${item.purchasePrice}" />
                            <input type="hidden" name="purchasePrice[]" class="price-hidden" value="${item.purchasePrice}" />
                        </td>
                        <td>
                            <input type="number" name="purchaseQty_display" class="count-input" min="0" value="${item.purchaseQty}" />
                            <input type="hidden" name="purchaseQty[]" class="qty-hidden" value="${item.purchaseQty}" />
                        </td>
                        <td><input type="text" name="total" class="total-display" readonly value="<fmt:formatNumber value='${item.purchasePrice * item.purchaseQty}'/>" /></td>
                    </tr>
                </c:forEach>

                <!-- 숨겨진 템플릿 -->
                <tr class="item-row template" style="display:none;">
                    <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                    <td><select class="top-category-select"><option value="">대분류 선택</option></select></td>
                    <td><select class="sub-category-select"><option value="">중분류 선택</option></select></td>
                    <td><select name="productId[]" class="item-select"><option value="">상품 선택</option></select></td>
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
$(function(){
    const clientId = $('input[name="clientId"]').val();

    // 기존 행 데이터 로드
    $('.item-row').not('.template').each(function(){
        const $row = $(this);
        loadTopCategories($row, clientId, $row.data('top-id'), $row.data('sub-id'), $row.data('product-id'));
    });

    // 대분류 변경 시 → 중분류 로드
    $(document).on('change', '.top-category-select', function(){
        const $row = $(this).closest('tr');
        $.get('/productCategory/sub', { parentId: $(this).val(), clientId }, function(data){
            fillSelect($row.find('.sub-category-select'), data, '중분류 선택');
            $row.find('.item-select').html('<option value="">상품 선택</option>');
        });
    });

    // 중분류 변경 시 → 상품 로드
    $(document).on('change', '.sub-category-select', function(){
        const $row = $(this).closest('tr');
        $.get('/product/byCategory/' + $(this).val(), function(data){
            fillSelect($row.find('.item-select'), data, '상품 선택', 'productId', 'productName', 'price');
        });
    });

    // 상품 선택 시 → 가격 세팅
    $(document).on('change', '.item-select', function(){
        const $row = $(this).closest('tr');
        const price = $(this).find(':selected').data('price') || 0;
        $row.find('.price-input, .price-hidden').val(price);
        calcRowTotal($row);
        calcSummary();
    });

    // 수량 변경 시 → 합계 반영
    $(document).on('input', '.count-input', function(){
        calcRowTotal($(this).closest('tr'));
        calcSummary();
    });

    // 행 추가
    $('.add-row').click(function(){
        const $new = $('.template').clone().removeClass('template').show();
        $('table.orderItems tbody').append($new);
        loadTopCategories($new, clientId);
    });

    // 선택 삭제
    $('#delete-selected').click(function(){
        $('.row-select:checked').closest('tr').not('.template').remove();
        calcSummary();
    });

    // 전체 선택
    $('#select-all').change(function(){
        $('.row-select').prop('checked', $(this).prop('checked'));
    });

    // 제출 시 유효성 검사
    $('#orderUpdate').submit(function(e){
        let hasProduct = false, valid = true, msg = '';
        $('.item-row').not('.template').each(function(){
            const productId = $(this).find('.item-select').val();
            const qty = parseInt($(this).find('.count-input').val(), 10);
            if (productId && qty > 0) { hasProduct = true; }
            else if (!productId) { $(this).find('input, select').removeAttr('name'); }
            else { valid = false; msg = '수량을 입력하세요.'; return false; }
        });
        if (!hasProduct || !valid) { alert(msg || '상품과 수량을 입력하세요.'); e.preventDefault(); }
    });

    // 공통 함수
    function loadTopCategories($row, clientId, topId, subId, productId){
        $.get('/productCategory/top', { clientId }, function(data){
            fillSelect($row.find('.top-category-select'), data, '대분류 선택', 'categoryId', 'categoryName', null, topId);
            if(topId) loadSubCategories($row, clientId, topId, subId, productId);
        });
    }
    function loadSubCategories($row, clientId, topId, subId, productId){
        $.get('/productCategory/sub', { parentId: topId, clientId }, function(data){
            fillSelect($row.find('.sub-category-select'), data, '중분류 선택', 'categoryId', 'categoryName', null, subId);
            if(subId) loadProducts($row, subId, productId);
        });
    }
    function loadProducts($row, subId, productId){
        $.get('/product/byCategory/' + subId, function(data){
            fillSelect($row.find('.item-select'), data, '상품 선택', 'productId', 'productName', 'price', productId);
        });
    }
    function fillSelect($select, list, defaultText, valueKey='categoryId', textKey='categoryName', priceKey=null, selectedVal=null){
        $select.empty().append(`<option value="">${defaultText}</option>`);
        list.forEach(item => {
            let option = $('<option>')
                .val(item[valueKey])
                .text(item[textKey])
                .prop('selected', item[valueKey] == selectedVal);
            if(priceKey && item[priceKey] != null) option.attr('data-price', item[priceKey]);
            $select.append(option);
        });
    }
    function calcRowTotal($row){
        const price = parseFloat($row.find('.price-input').val()) || 0;
        const qty = parseInt($row.find('.count-input').val()) || 0;
        $row.find('.total-display').val((price * qty).toLocaleString());
        $row.find('.qty-hidden').val(qty);
    }
    function calcSummary(){
        let totalQty = 0, totalAmt = 0;
        $('.item-row').not('.template').each(function(){
            totalQty += parseInt($(this).find('.count-input').val()) || 0;
            totalAmt += parseFloat(($(this).find('.total-display').val() || '0').replace(/,/g,'')) || 0;
        });
        $('#sum-quantity').val(totalQty);
        $('#sum-total').val(totalAmt.toLocaleString());
    }
});
</script>
</body>
</html>
