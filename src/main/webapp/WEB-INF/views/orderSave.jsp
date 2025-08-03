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
        <form id="orderSave" action="/order/save" method="post">

            <!-- 저장 -->
            <input type="submit" id="save-order" class="btn btn-blue" value="저장">

            <!-- 거래처 -->
            <table class="clientsName">
                <tr>
                    <th class="vertical-label"><div>거래처명</div></th>
                    <td>
                        <!-- 거래처 선택 -->
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
               <!-- 숨겨진 템플릿 행 -->
               <tr class="item-row template" style="display:none;">
                   <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                   <td>
                      <!-- 상품 선택 -->
                      <select name="productId" class="item-select">
                          <option value="">상품을 선택하세요</option>
                      </select>
                   </td>
                   <td><input type="number" class="price-input" readonly /></td>
                   <td><input type="number" name="count" class="count-input" min="0" /></td>
                   <td><input type="text" name="total" class="total-display" readonly /></td>
               </tr>

               <!-- 기본 행 -->
               <tr class="item-row">
                   <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                   <td>
                       <select name="productId" class="item-select">
                           <option value="">상품을 선택하세요</option>
                       </select>
                   </td>
                   <td><input type="number" class="price-input" readonly /></td>
                   <td><input type="number" name="count" class="count-input" min="0" /></td>
                   <td><input type="text" name="total" class="total-display" readonly /></td>
               </tr>
                </tbody>
            </table>
        </form>
    </div>
</div>

<script>
$(document).ready(function(){
    // 가격 초기화
    $('.price-input').val(0);
    $('.total-display').val(0);

    // 거래처 선택 시 상품 목록 불러오기
    $(document).on('change', '#clientSelect', function() {
        let clientId = $(this).val();
        if (!clientId) {
            $('.item-select').empty().append('<option value="">상품을 선택하세요</option>');
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
    });

    // 전체 선택 체크박스
    $('#select-all').on('change', function(){
        $('.row-select').prop('checked', $(this).prop('checked'));
    });

    // 선택 삭제
    $('#delete-selected').on('click', function(){
        $('.row-select:checked').closest('tr').not('.template').remove();
        calcSummary();
    });
});

// Ajax로 상품 목록 가져오기
function loadProductsByClient(clientId) {
    $.ajax({
        url: '/product/byClient',
        type: 'GET',
        data: { clientId: clientId },
        dataType: 'json',
        success: function(products) {
            if (!Array.isArray(products) || products.length === 0) {
                $('.item-select').empty().append('<option value="">상품을 선택하세요</option>');
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
        let name = p.productName || p.description || '(이름 없음)';
        $select.append(
            '<option value="' + p.productId + '" data-price="' + p.price + '">' + name + '</option>'
        );
    });

    if (products.length > 0) {
        $select.find('option:eq(1)').prop('selected', true);
        setPriceBySelected($select);
    }
}

// 가격 반영
function setPriceBySelected($select){
    let $row = $select.closest('tr');
    let selectedValue = $select.val();

    // 거래처 미선택이거나 "상품을 선택하세요" 선택 시
    if (!selectedValue) {
        $row.find('.price-input').val(0);
        calcRowTotal($row);
        return;
    }

    let price = $select.find(':selected').data('price') || 0;
    $row.find('.price-input').val(price);
    calcRowTotal($row);
}

// 행별 합계
function calcRowTotal($row){
    let price = parseFloat($row.find('.price-input').val()) || 0;
    let count = parseInt($row.find('.count-input').val()) || 0;
    let total = price * count;
    $row.find('.total-display').val(total.toLocaleString());
}

// 전체 합계
function calcSummary(){
    let totalQuantity = 0;
    let totalAmount = 0;
    $('.item-row').each(function(){
        let count = parseInt($(this).find('.count-input').val()) || 0;
        let rowTotal = parseFloat($(this).find('.total-display').val().replace(/,/g,'')) || 0;
        totalQuantity += count;
        totalAmount += rowTotal;
    });
    $('#sum-quantity').val(totalQuantity);
    $('#sum-total').val(totalAmount.toLocaleString());
}
</script>


</body>
</html>
