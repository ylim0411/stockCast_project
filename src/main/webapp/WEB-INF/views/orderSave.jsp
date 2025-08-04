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
<div class="container">
    <div class="title-box">
        <p class="sub-title">발주 관리</p>
        <h2 class="title">발주서 작성</h2>
    </div>

    <div>
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
                    <th>상품명</th>
                    <th>구매단가</th>
                    <th>수량</th>
                    <th>총 금액</th>
                </tr>
                </thead>
                <tbody>

               <!-- 숨겨진 템플릿 행 -->
               <tr class="item-row template" style="display:none;">
                   <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                   <td>
                       <select name="productId[]" class="item-select">
                           <option value="">상품을 선택하세요</option>
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

               <!-- 기본 행 -->
               <tr class="item-row">
                   <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                   <td>
                       <select name="productId[]" class="item-select">
                           <option value="">상품을 선택하세요</option>
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

    // 가격 입력값이 변경될 때 hidden 필드에 값 복사
    $(document).on('input change', '.price-input', function() {
        $(this).siblings('.price-hidden').val($(this).val());
    });

    // 수량 입력값이 변경될 때 hidden 필드에 값 복사
    $(document).on('input change', '.count-input', function() {
        $(this).siblings('.qty-hidden').val($(this).val());
    });

    // 상품 선택 시 가격 반영 + hidden 동기화
    function setPriceBySelected($select){
        let $row = $select.closest('tr');
        let selectedValue = $select.val();
        if (!selectedValue) {
            $row.find('.price-input').val(0);
            $row.find('.price-hidden').val(0);
            calcRowTotal($row);
            return;
        }
        let price = $select.find(':selected').data('price') || 0;
        $row.find('.price-input').val(price);
        $row.find('.price-hidden').val(price);
        calcRowTotal($row);
    }

    // 행별 합계 계산 + hidden 동기화
    function calcRowTotal($row){
        let price = parseFloat($row.find('.price-input').val()) || 0;
        let count = parseInt($row.find('.count-input').val()) || 0;
        let total = price * count;
        $row.find('.total-display').val(total.toLocaleString());
        $row.find('.qty-hidden').val(count);
    }

    // 전체 합계 계산
    function calcSummary(){
        let totalQuantity = 0;
        let totalAmount = 0;
        $('.item-row').each(function(){
            let count = parseInt($(this).find('.count-input').val()) || 0;
            let rowTotal = parseFloat(($(this).find('.total-display').val() || '0').replace(/,/g,'')) || 0;
            totalQuantity += count;
            totalAmount += rowTotal;
        });
        $('#sum-quantity').val(totalQuantity);
        $('#sum-total').val(totalAmount.toLocaleString());
    }

    // 가격/수량/금액 전체 리셋 함수
    function resetAllPrices() {
        $('.price-input').val(0);
        $('.price-hidden').val(0);
        $('.count-input').val('');
        $('.qty-hidden').val(0);
        $('.total-display').val(0);
    }

    // 폼 전송 시
    $('#orderSave').on('submit', function(e) {

        let valid = true;
        let message = '';

        // 거래처 선택 확인
        if (!$('#clientSelect').val()) {
             alert('거래처를 선택하세요.');
             e.preventDefault();
             return false; // 여기서 바로 종료
         }

        // 상품명, 수량 확인
        $('.item-row').each(function(){
           // 숨겨진 템플릿 행 제외
           if ($(this).hasClass('template')) return;

           let productId = $(this).find('.item-select').val();
           let qty = parseInt($(this).find('.count-input').val(), 10);

           if (!productId) {
               valid = false;
               message = '상품명을 선택하세요.';
               return false;
           }
           if (!qty || qty <= 0) {
               valid = false;
               message = '수량을 입력하세요.';
               return false;
           }
        });

         // 유효성 검사 실패 시 제출 막기
        if (!valid) {
            alert(message);
            e.preventDefault();
            return false;
        }

        $('.item-row').each(function(){
            if (!$(this).find('.item-select').val()) {
                $(this).remove();
            }
        });

        // 발주번호 & 등록일 값 설정
        $('#orderIdHidden').val($('#order-number').text());
        $('#orderDateHidden').val($('#order-date').text());
    });

    // 페이지 로드 시 발주번호 / 등록일 불러오기
    $.ajax({
        url: '/order/new-info',
        type: 'GET',
        success: function(data) {
            $('#order-number').text(data.orderNumber);
            $('#order-date').text(data.orderDate);
        },
        error: function() {
            console.error("발주번호/등록일 불러오기 실패");
        }
    });

    // 초기 가격/금액 0 세팅
    resetAllPrices();

    // 거래처 선택 시 상품 목록 불러오기
    $(document).on('change', '#clientSelect', function() {
        let clientId = $(this).val();
        if (!clientId) {
            $('.item-select').empty().append('<option value="">상품을 선택하세요</option>');
            resetAllPrices();
            calcSummary();
            return;
        }
        loadProductsByClient(clientId);
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

        if (window.currentProducts) {
            populateProducts($newRow.find('.item-select'), window.currentProducts);
        }
        updateSelectAllState();
    });

    // 전체 선택 체크박스
    $(document).on('change', '#select-all', function(){
        let checked = $(this).prop('checked');
        $('.row-select').not(':hidden').prop('checked', checked);
        updateSelectAllState();
    });

    // 개별 체크박스 클릭 시 전체선택 상태 반영
    $(document).on('change', '.row-select', function(){
        updateSelectAllState();
    });

    // 전체 선택 상태 갱신 함수
    function updateSelectAllState() {
        let total = $('.row-select').not(':hidden').length;
        let checked = $('.row-select:checked').not(':hidden').length;
        $('#select-all').prop('checked', total > 0 && total === checked);
    }

    // 선택 삭제 버튼
    $(document).on('click', '#delete-selected', function(){
        $('.row-select:checked').closest('tr').not('.template').remove();
        calcSummary();
        updateSelectAllState();
    });

    // 상품 목록 불러오기
    function loadProductsByClient(clientId) {
        $.ajax({
            url: '/product/byClient',
            type: 'GET',
            data: { clientId: clientId },
            dataType: 'json',
            success: function(products) {
                if (!Array.isArray(products) || products.length === 0) {
                    $('.item-select').empty().append('<option value="">상품을 선택하세요</option>');
                    resetAllPrices();
                    calcSummary();
                    return;
                }
                window.currentProducts = products;
                $('.item-select').each(function(){
                    populateProducts($(this), products);
                });
            },
            error: function() {
                alert("상품 목록을 불러오는 중 오류가 발생했습니다.");
            }
        });
    }

    // 상품 select 채우기
    function populateProducts($select, products) {
        $select.empty().append('<option value="">상품을 선택하세요</option>');
        products.forEach(function(p) {
            let name = p.productName || '(이름 없음)';
            $select.append('<option value="' + p.productId + '" data-price="' + p.price + '">' + name + '</option>');
        });
        $select.val('');
        setPriceBySelected($select);
    }
});
</script>

</body>
</html>
