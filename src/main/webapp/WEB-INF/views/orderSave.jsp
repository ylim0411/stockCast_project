<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>발주서 작성</title>
    <script src="${pageContext.request.contextPath}/static/js/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
</head>
<body>
<div class="containerAuto">
    <div class="title-box">
        <p class="sub-title">발주 관리</p>
        <h2 class="title">발주서 작성</h2>
    </div>

 <div class="section-wrap">
        <form id="orderSave" action="/order/orderSave" method="post">

            <!-- 숨겨진 필드 -->
            <input type="hidden" name="orderId" id="orderIdHidden">
            <input type="hidden" name="orderDate" id="orderDateHidden">

            <!-- 저장 -->
            <div class="btn-box">
            <input type="submit" id="save-order" class="btn submit-btn" value="작성">
            </div>

            <!-- 거래처 -->
            <table class="clientsName">
                <tr>
                    <th class="vertical-label"><div>거래처명</div></th>
                    <td>
                        <select id="clientSelect" name="clientId" class="client-select">
                            <option value="">거래처를 선택하세요</option>
                            <c:forEach var="c" items="${clients}">
                                <option value="${c.clientId}">${c.clientName}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
            </table>

            <!-- 발주 요약 -->
            <table class="orderSummary" aria-label="발주 요약">
                <tbody>
                <tr>
                    <th class="vertical-label"><div>발주번호</div></th>
                    <td><span id="order-number"></span></td>
                    <th class="vertical-label"><div>발주등록일</div></th>
                    <td><span id="order-date"></span></td>
                </tr>
                <tr>
                    <th class="vertical-label"><div>수량</div></th>
                    <td><input type="text" id="sum-quantity" readonly value="0"></td>
                    <th class="vertical-label"><div>총금액</div></th>
                    <td><input type="text" id="sum-total" readonly value="0"></td>
                </tr>
                </tbody>
            </table>

            <div class="btn-box" style="margin:20px;">
                <button type="button" class="add-row btn btn-blue">행 추가</button>
                <button type="button" id="delete-selected" class="btn btn-red">선택 삭제</button>
            </div>

            <!-- 발주 상세 -->
            <table class="orderItems" aria-label="상세 상품 목록">
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
                <!-- 기본 행 -->
                <tr class="item-row">
                    <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                    <td>
                        <select class="top-category-select">
                            <option value="">대분류 선택</option>
                        </select>
                    </td>
                    <td>
                        <select class="sub-category-select">
                            <option value="">중분류 선택</option>
                        </select>
                    </td>
                    <td>
                        <select name="productId[]" class="item-select">
                            <option value="">상품 선택</option>
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

                <!-- 숨겨진 템플릿 행 -->
                <tr class="item-row template" style="display:none;">
                    <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                    <td>
                        <select class="top-category-select">
                            <option value="">대분류 선택</option>
                        </select>
                    </td>
                    <td>
                        <select class="sub-category-select">
                            <option value="">중분류 선택</option>
                        </select>
                    </td>
                    <td>
                        <select name="productId[]" class="item-select">
                            <option value="">상품 선택</option>
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
      </div> <!-- section-wrap -->
</div> <!-- containerAuto -->

<script>
$(document).ready(function(){

    // 발주번호 + 발주등록일 로드
    $.get('/order/new-info', function(data){
        $('#order-number').text(data.orderNumber);
        $('#order-date').text(data.orderDate);
        $('#orderIdHidden').val(data.orderNumber);
        $('#orderDateHidden').val(data.orderDate);
    });

    // 폼 전송 유효성 검사
    // 폼 전송 유효성 검사 부분 수정
    $('#orderSave').on('submit', function(e){
        let clientId = $('#clientSelect').val();
        if (!clientId) {
            alert('거래처를 선택하세요.');
            e.preventDefault();
            return false;
        }

        let hasProduct = false;
        let valid = true;
        let message = '';

        $('.item-row').not('.template').each(function(){
            let productId = $(this).find('.item-select').val();
            let qty = parseInt($(this).find('.count-input').val(), 10);

            if (productId && qty > 0) {
                hasProduct = true;
            } else if (!productId) {
                // 상품이 없는 행은 name 속성 제거해서 서버 전송 안 함
                $(this).find('input, select').removeAttr('name');
            } else if (productId && (!qty || qty <= 0)) {
                valid = false;
                message = '수량을 입력하세요.';
                return false; // break
            }
        });

        if (!hasProduct) {
            alert('최소 1개 이상의 상품을 선택하고 수량을 입력하세요.');
            e.preventDefault();
            return false;
        }

        if (!valid) {
            alert(message);
            e.preventDefault();
            return false;
        }

        // hidden 필드 값 보정
        $('.item-row').not('.template').each(function(){
            let price = $(this).find('.price-input').val();
            let qty = $(this).find('.count-input').val();
            $(this).find('.price-hidden').val(price ? price : 0);
            $(this).find('.qty-hidden').val(qty ? qty : 0);
        });
    });

    // 가격, 수량 입력 시 hidden 값 반영
    $(document).on('input change', '.price-input', function(){
        let price = $(this).val();
        $(this).siblings('.price-hidden').val(price ? price : 0);
    });

    $(document).on('input change', '.count-input', function(){
        let qty = $(this).val();
        $(this).siblings('.qty-hidden').val(qty ? qty : 0); // 값 없으면 0
    });

    // 합계 계산 함수
    function calcRowTotal($row){
        let price = parseFloat($row.find('.price-input').val()) || 0;
        let count = parseInt($row.find('.count-input').val()) || 0;
        let total = price * count;

        $row.find('.total-display').val(total.toLocaleString());
        $row.find('.qty-hidden').val(count);
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

    // 대분류/중분류/상품 로드 이벤트
    $(document).on('change', '#clientSelect', function(){
        $('.item-row').not('.template').each(function(){ loadTopCategories($(this)); });
    });

    function loadTopCategories($row){
        let clientId = $('#clientSelect').val();
        if (!clientId) return;
        $.get('/productCategory/top', { clientId }, function(data){
            let $top = $row.find('.top-category-select').empty().append('<option value="">대분류 선택</option>');
            data.forEach(c => $top.append('<option value="'+c.categoryId+'">'+c.categoryName+'</option>'));
        });
    }

    $(document).on('change', '.top-category-select', function(){
        let $row = $(this).closest('tr');
        $.get('/productCategory/sub', {
            parentId: $(this).val(),
            clientId: $('#clientSelect').val()
        }, function(data){
            let $sub = $row.find('.sub-category-select').empty().append('<option value="">중분류 선택</option>');
            data.forEach(c => $sub.append('<option value="'+c.categoryId+'">'+c.categoryName+'</option>'));
        });
    });

    $(document).on('change', '.sub-category-select', function(){
        let $row = $(this).closest('tr');
        $.get('/product/byCategory/' + $(this).val(), function(data){
            let $prod = $row.find('.item-select').empty().append('<option value="">상품 선택</option>');
            data.forEach(p => $prod.append('<option value="'+p.productId+'" data-price="'+p.price+'">'+p.productName+'</option>'));
        });
    });

    // 상품 선택 시 가격 반영 + 중복 방지
    $(document).on('change', '.item-select', function(){
        let $row = $(this).closest('tr');
        let val = $(this).val();
        if (!val) return;

        let duplicate = false;
        $('.item-select').not(this).each(function(){
            if ($(this).val() === val) { duplicate = true; return false; }
        });
        if (duplicate) {
            alert('이미 선택한 상품입니다.');
            $(this).val('');
            $row.find('.price-input, .price-hidden, .count-input, .qty-hidden, .total-display').val('');
            return;
        }

        let price = $(this).find(':selected').data('price') || 0;
        $row.find('.price-input, .price-hidden').val(price);
        calcRowTotal($row);
        calcSummary();
    });

    // 수량 변경 시 합계 반영
    $(document).on('input', '.count-input', function(){
        calcRowTotal($(this).closest('tr'));
        calcSummary();
    });

    // 행 추가
    $('.add-row').click(function(){
        let $new = $('.template').clone().removeClass('template').show();
        $new.find('input').val('');
        $('table.orderItems tbody').append($new);
        loadTopCategories($new);
    });
});
</script>
</body>
</html>
