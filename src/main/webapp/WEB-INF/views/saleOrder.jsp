<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>무인점포</title>
    <script src="${pageContext.request.contextPath}/static/js/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
</head>
<body>
<div class="containerAuto">
    <div class="title-box">
        <p class="sub-title">판매 모의</p>
        <h2 class="title">${storeName}</h2>
    </div>

 <div class="section-wrap">
        <form id="saleSave" action="saleOrder" method="post">
            <input type="hidden" name="saleId" value="${maxSaleId}">
            <input type="hidden" name="today" value="${today}">
            <div class="btn-box">
            <input type="submit" id="save-order" class="btn submit-btn" value="주문">
            </div>
            <table class="orderSummary" aria-label="발주 요약">
                <tbody>
                <tr>
                    <th class="vertical-label"><div>주문번호</div></th>
                    <td name="saleId">${maxSaleId}</td>
                    <th class="vertical-label"><div>주문일</div></th>
                    <td name="today">${today}</td>
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

            <!-- 주문 상세 -->
            <table class="orderItems" aria-label="상세 상품 목록">
                <thead>
                <tr>
                    <th><input type="checkbox" id="select-all" /></th>
                    <th>상품명</th>
                    <th>판매단가</th>
                    <th>수량</th>
                    <th>총 금액</th>
                </tr>
                </thead>
                <tbody>
                <tr class="item-row">
                    <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                    <td>
                        <select name="productName[]" class="product-select">
                            <option value="" selected disabled hidden>상품선택</option>
                            <c:forEach var="product" items="${products}">
                                <option value="${product.productName}">${product.productName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <span class="product-price"></span>
                    </td>
                    <td>
                        <input type="number" name="purchaseQty_display" class="count-input" min="0" />
                        <input type="hidden" name="purchaseQty[]" class="qty-hidden" />
                    </td>
                    <td>
                        <input type="text" name="total" class="total-display" readonly />
                    </td>
                </tr>

                <tr class="item-row template" style="display:none;">
                    <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                    <td>
                        <select class="product-select">
                            <option value="" selected disabled hidden>상품선택</option>
                            <c:forEach var="product" items="${products}">
                                <option value="${product.productName}">${product.productName}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <span class="product-price"></span>
                    </td>
                    <td>
                        <input type="number" name="purchaseQty_display" class="count-input" min="0" />
                        <input type="hidden" class="qty-hidden" />
                    </td>
                    <td>
                        <input type="text" name="total" class="total-display" readonly />
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
      </div> <!-- section-wrap -->
</div> <!-- containerAuto -->

<script>
$(document).ready(function(){

    // 행 추가 버튼 클릭 시 이벤트 리스너
    $('.add-row').click(function(){
        // 템플릿 행을 복제 (깊은 복제)
        let $newRow = $('.template').clone(true).removeClass('template').show();

        // 복제된 새 행에 name 속성 추가
        $newRow.find('.product-select').attr('name', 'productName[]');
        $newRow.find('.qty-hidden').attr('name', 'purchaseQty[]');

        // 복제된 input 필드들의 값을 초기화
        $newRow.find('input').val('');

        // 테이블에 새 행 추가
        $('table.orderItems tbody').append($newRow);

        updateProductOptions();
        calcSummary();
    });
    // 수량 입력 시 총 금액 및 재고 확인
    $(document).on('change', '.count-input', function(){
        let $currentRow = $(this).closest('tr');
        let selectedProductName = $currentRow.find('.product-select').val();
        let enteredQuantity = parseInt($(this).val()) || 0;

        // 상품이 선택되어 있을 때만 재고 확인
        if (selectedProductName) {
            // 서버에 재고 정보 요청 (Ajax)
            $.ajax({
                url: "/sales/getStock", // 재고를 가져올 새로운 컨트롤러 경로
                type: "post",
                data: { productName: selectedProductName },
                success: function(availableStock) {
                    if (enteredQuantity > availableStock) {
                        alert('재고가 부족합니다. 남은 재고: ' + availableStock + '개');
                        // 입력값을 재고 수량으로 변경하거나 0으로 초기화
                        $currentRow.find('.count-input').val(availableStock);
                        enteredQuantity = availableStock; // 로직의 일관성을 위해 변수도 업데이트
                    }

                    // 재고 확인 후 기존의 총 금액 계산 함수 호출
                    calculateRowTotal($currentRow.find('.count-input'));
                },
                error: function(xhr, status, error) {
                    console.error("재고 확인 중 오류 발생:", xhr.status, error);
                    alert("재고 정보를 가져오는 데 실패했습니다.");
                    // 오류 발생 시에도 총 금액 계산을 위해 호출
                    calculateRowTotal($currentRow.find('.count-input'));
                }
            });
        } else {
            // 상품이 선택되지 않았을 경우, 기존 로직만 실행
            calculateRowTotal($(this));
        }
    });
    // 선택 삭제 버튼 클릭 시 이벤트 리스너
    $('#delete-selected').click(function(){
        $('.item-row .row-select:checked').each(function(){
            $(this).closest('tr').remove();
        });
        updateProductOptions();
        calcSummary();
    });

    // 전체 선택/해제
    $('#select-all').click(function(){
        $('.row-select').prop('checked', $(this).prop('checked'));
    });

    // 개별 체크박스 클릭 시 전체 선택 체크박스 상태 업데이트
    $(document).on('click', '.row-select', function(){
        let totalCheckboxes = $('.row-select').not('#select-all').length;
        let checkedCheckboxes = $('.row-select:checked').not('#select-all').length;
        $('#select-all').prop('checked', totalCheckboxes === checkedCheckboxes);
    });

    // 상품 선택 시 발생하는 이벤트 (AJAX 포함)
    $(document).on('change', '.product-select', function(){
        let selectedValue = $(this).val();
        let $currentRow = $(this).closest('tr');

        updateProductOptions();

        if (selectedValue) {
            $.ajax({
                url: "/sales/salePrice",
                type: "post",
                data: { productName: selectedValue },
                success: function(data) {
                    $currentRow.find('.product-price').text(data);
                    calculateRowTotal($currentRow.find('.count-input'));
                },
                error: function(xhr, status, error) {
                     console.error("AJAX 요청 오류 발생:", xhr.status, error);
                     $currentRow.find('.product-price').text('');
                     $currentRow.find('.count-input').val(0);
                     calculateRowTotal($currentRow.find('.count-input'));
                }
            });
        } else {
            $currentRow.find('.product-price').text('');
            $currentRow.find('.count-input').val(0);
            calculateRowTotal($currentRow.find('.count-input'));
        }
    });

    // 수량 입력 시 총 금액 및 요약 업데이트
    $(document).on('keyup change', '.count-input', function(){
        calculateRowTotal($(this));
    });

    // 행별 총 금액 계산 함수
    function calculateRowTotal(quantityInput) {
        let $row = quantityInput.closest('tr');
        let priceText = $row.find('.product-price').text();
        let price = priceText ? parseFloat(priceText.replace(/,/g, '')) : 0;
        let quantity = parseInt(quantityInput.val()) || 0;
        let total = price * quantity;

        $row.find('.total-display').val(total.toLocaleString());
        $row.find('.qty-hidden').val(quantity);
        calcSummary();
    }

    // 전체 요약 (총 수량, 총 금액) 계산 함수
    function calcSummary() {
        let totalQuantity = 0;
        let grandTotal = 0;

        $('.item-row').not('.template').each(function() {
            let quantity = parseInt($(this).find('.qty-hidden').val()) || 0;
            let rowTotal = parseInt($(this).find('.total-display').val().replace(/,/g, '')) || 0;

            totalQuantity += quantity;
            grandTotal += rowTotal;
        });

        $('#sum-quantity').val(totalQuantity);
        $('#sum-total').val(grandTotal.toLocaleString());
    }

    function updateProductOptions() {
        // 이미 선택된 상품 목록을 배열에 저장
        let selectedProducts = $('.product-select').map(function() {
            return $(this).val();
        }).get();

        // 모든 상품 선택 옵션을 순회
        $('.product-select option').each(function() {
            let optionValue = $(this).val();
            // 현재 옵션이 이미 선택된 목록에 포함되어 있으면
            if (optionValue && selectedProducts.includes(optionValue)) {
                // '상품선택' 옵션과 현재 행의 선택된 옵션을 제외하고 비활성화
                if ($(this).closest('select').val() !== optionValue) {
                    $(this).prop('disabled', true);
                }
            } else {
                // 선택되지 않은 옵션은 활성화
                $(this).prop('disabled', false);
            }
        });
    }

    // 페이지 로드 시 초기 요약 계산 및 옵션 상태 업데이트
    calcSummary();
    updateProductOptions();
});
</script>
</body>
</html>
